from flask import Flask, make_response, request, render_template
from random import random         #get random numbers
import jwt
import datetime
import calculator as cal
import sqlite_functions as sq
#-------------------------------------secret key variables------------------------------------
SECRET_KEY = "C7E2F9D46E9"

#--------------------------------------functions for the server-------------------------------------
def create_token(username, password, user_id):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=15)      #get current date + 15 days
    token = jwt.encode({'user_id': user_id,'username':username, 'exp': validity}, SECRET_KEY, "HS256")      #user id any number since we don't have a database for users
    #HS256" the hashing algorithm SHA 256
    return token

def verify_token(token):
    if token:   #i ftoken exists
        decoded_token = jwt.decode(token, SECRET_KEY, "HS256")
        print(decoded_token)
    #check whether infor in coded token is correct or not
        return True #if inforamtion is correct, otherwise return false
    else:  # else no token so here
        return False


 #------------------------------------server opening ---------------------------------------
flask_app = Flask(__name__)

@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    isUserLoggedIn = False
    if 'token' in request.cookies: #if there is a token in cookies return true
        isUserLoggedIn = verify_token(request.cookies['token'])
    if isUserLoggedIn:  #if there is a token go here
        return render_template('caltemplate.html')
    else:  # if no token in cookies go here
        user_id = random()
        print(f"User ID: {user_id}")
        resp = make_response(render_template('mainpage.html', foo=42))
        resp.set_cookie('user_id', str(user_id))        #sets a cookie on the user attached to the response
        return resp

@flask_app.route('/login', methods = ['POST'])      #login page
def login_page():
    #need to render the login.html page
    return render_template('login.html')

@flask_app.route('/addlogin', methods = ['POST'])
def addlogin_page():
    #need to render the login.html page
    return render_template('addlogin.html')

@flask_app.route('/accountcreated', methods = ['POST'])
def accountcreated_page():
    data = request.form   #retreive data from the post from the login page
    username = data['username']       # store username and password from html
    password = data['password']
    check = sq.check_username_in_db(username,password)
    if check == True:
        return render_template('addlogin.html', reason = 'Someone already has this username')
    else:
        sq.table_insert(username,password)
        return render_template('accountcreated.html')


@flask_app.route('/authenticate', methods = ['POST']) #authpage get to here form login
def authenticate_users():
    data = request.form   #retreive data from the post from the login page
    username = data['username']       # store username and password from html
    password = data['password']
    check = sq.check_user_in_db(username,password)
    if check == True:
        #create token
        user_token = create_token(username,password, 1200)
        #make response to resend
        resp = make_response(render_template('authpage.html', foo=42))
        #token set to a cookie for responce
        resp.set_cookie('token', user_token)
        return resp   #retreive data from the post from the login page
    else:
        return render_template('login.html')


@flask_app.route('/results', methods = ['POST']) #authpage get to here form login
def results_users():
    data = request.form   #retreive data from the post from the login page
    num1 = float(data['number1'])       # store username and password from html
    num2 = float(data['number2'])
    calculatorObject = cal.CalculatorClass(num1, num2)            #makes a calculator class object which contains number 1 and number 2
    result = calculatorObject.checklist()
    add,sub,mul,divide = result[2],result[3],result[4],result[5]                               #makes a list of results to use
    resp = make_response(render_template('results.html', number1 = num1, number2 = num2, a = add,s = sub,m = mul,d = divide ))

    return resp





#-------------------------------------run server -------------------------------------------
if __name__ == "__main__":
    print("This is a secure calculator Server")
    flask_app.run(host = "0.0.0.0", debug = True, ssl_context=('cert/cert.pem','cert/key.pem'))   #runs the flask app so create a server debug =True means that it will auto update
