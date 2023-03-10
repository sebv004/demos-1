from flask import Flask
import os
import time
import logging
from logging import StreamHandler
from datadog_api_client.v2 import ApiClient, ApiException, Configuration
from datadog_api_client.v2.api import logs_api
from datadog_api_client.v2.models import *
from faker import Faker
 
class DDHandler(StreamHandler):
    def __init__(self, configuration, service_name, ddsource):
        StreamHandler.__init__(self)
        self.configuration = configuration
        self.service_name = service_name
        self.ddsource = ddsource
 
    def emit(self, record):
        msg = self.format(record)
 
        with ApiClient(self.configuration) as api_client:
            api_instance = logs_api.LogsApi(api_client)
            body = HTTPLog(
                [
                    HTTPLogItem(
                        ddsource=self.ddsource,
                        ddtags="env:{}".format(
                            os.getenv("ENV"),
 
                        ),
                        message=msg,
                        service=self.service_name,
                    ),
                ]
            )
 
            try:
                # Send logs
                api_response = api_instance.submit_log(body)
            except ApiException as e:
                print("Exception when calling LogsApi->submit_log: %s\n" % e)
 
 
class Logging(object):
    def __init__(self, service_name, ddsource, logger_name='demoapp'):
 
        self.service_name = service_name
        self.ddsource = ddsource
        self.logger_name = logger_name
 
 
        self.configuration = Configuration()
        format = "[%(asctime)s] %(name)s %(levelname)s %(message)s"
        self.logger = logging.getLogger(self.logger_name)
        formatter = logging.Formatter(
            format,
        )
 
 
        # Logs to Datadog
        dd = DDHandler(self.configuration, service_name=self.service_name,ddsource=self.ddsource)
        dd.setLevel(logging.INFO)
        dd.setFormatter(formatter)
        self.logger.addHandler(dd)
 
        if logging.getLogger().hasHandlers():
            logging.getLogger().setLevel(logging.INFO)
        else:
            logging.basicConfig(level=logging.INFO)


app = Flask(__name__)


@app.route('/hello')
def helloIndex():
    return 'Hello World from Python Flask!'

@app.route('/callme')
def callme():
    version= "3.0"
    color= "#e033ff" #Blue 44B3C2 and Yellow F1A94E, e033ff purple
    return "<div class='pod' style='background:%s'> ver: %s\n </div>" % (color, version)
    #return 'callme'

@app.errorhandler(500)
def handle_500(error):
    return str(error), 500



#app.run(host='0.0.0.0', port=5000)

if __name__ == '__main__':
    app.run()
    
    os.environ['DD_API_KEY'] = "3860cd0bcba5a849c1041eef72c3f682"
    os.environ['DD_SITE'] ="datadoghq.eu"
    os.environ['ENV'] = "DEV"
 
    logger = Logging(service_name='first-service', ddsource='source1', logger_name='demoapp')
    for i in range(1, 10):
        _instance = Faker()
 
 
        _data = {
            "first_name": _instance.first_name()
        }
        logger.logger.info(_data)
        logger.logger.error(_data)
        time.sleep(1)