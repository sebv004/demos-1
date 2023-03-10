from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics


app = Flask(__name__)
metrics = PrometheusMetrics(app)

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

@app.route('/metrics')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype=CONTENT_TYPE_LATEST)

#app.run(host='0.0.0.0', port=5000)

if __name__ == '__main__':
    app.run()