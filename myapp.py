from flask import Flask
import platform

app = Flask(__name__)

@app.route("/")
def system_info():
    system = platform.system()
    release = platform.release()
    version = platform.version()
    return f"<h1>System Information:</h1><p>System: {system}</p><p>Release: {release}</p><p>Version: {version}</p>"

if __name__ == "__main__":
    app.run(app.run(host='0.0.0.0', port=8080)
