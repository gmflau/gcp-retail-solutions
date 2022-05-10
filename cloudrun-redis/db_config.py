from app import app
from flaskext.mysql import MySQL


mysql = MySQL()
 
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'redis'
app.config['MYSQL_DATABASE_DB'] = 'roytuts'
app.config['MYSQL_DATABASE_HOST'] = '34.72.192.90'
app.config['MYSQL_DATABASE_PORT'] = 3306
mysql.init_app(app)
