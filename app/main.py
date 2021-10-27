from flask import Flask, make_response, request, render_template, redirect, jsonify
from random import random         #get random numbers
import jwt
import datetime
import calculator as cal
import sqlite_functions as sq
#-------------------------------------secret key variables------------------------------------
SECRET_KEY = "C7E2F9D46E9"

# @component Internet:Guest (#guest)
# @component Internet:AuthenticatedUser (#auser)

# @threat Out of Scope (#out)
# @exposes #guest to Out of scope with cannot change

# @threat Out of Scope (#out)
# @exposes #auser to Out of scope with cannot change

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
# @component Developer_Computer:Jenkins:Dockerhub:Container (#container)
# @component CalcApp:Web_Server:Index (#index)

# @connects #app_server to #container with Hosting
# @connects #container to #index with Running

# @connects #guest to #index with HTTPs-GET
# @connects #index to #guest with HTTPs-GET

# @connects #auser to #index with HTTPs-POST
# @connects #index to #auser with HTTPs-POST

# @threat Cross site scripting (reflected) (#xss)
# @exposes #index to javascript manipulation with #xss

# @threat Buffer overflow (#buffover)
# @exposes #index to overwriting memory of backend web processes. throws sevrer 500 error with #buffover

# @threat Absence of anti-CSRF tokens (#csfr)
# @exposes #index to tampering manipulation with #csrf
# @exposes #results to tampering manipulation with #csrf
# @exposes #authenticated to tampering manipulation with #csrf



# @threat No cache control header set (#cache)
# @exposes #index to information disclosure with #cache
# @exposes #login to information disclosure with #cache
# @exposes #logout to information disclosure with #cache
# @exposes #ac to information disclosure with #cache


@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    print(request.headers)
    isUserLoggedIn = False
    if 'token' in request.cookies: #if there is a token in cookies return true
        isUserLoggedIn = verify_token(request.cookies['token'])
    if isUserLoggedIn:  #if there is a token go here
        return render_template('caltemplate.html')
    else:  # if no token in cookies go here
        user_id = random()
        print(f"User ID: {user_id}")
        resp = make_response(render_template('mainpage.html', foo=42))
        resp.set_cookie('user_id', str(user_id), httponly=True, secure=True , samesite='Strict')        #sets a cookie on the user attached to the response
        return resp

# @component CalcApp:Web_Server:Login (#login)
# @connects #index with #login with HTTPs-POST
# @connects #login with #index with HTTPs-POST
# @connects #guest to #login with HTTPs-POST
# @connects #login to #guest with HTTPs-POST

# @control Sanitise SQL inputs (#sanitise)
# @threat SQL injection (#sqlinjection)
# @mitigates #login against ##sqlinjection with #sanitise

# @threat Brute force attack (#brute)
# @exposes #login to privilege escalation with #brute
# @exposes #index to information disclosure with #brute
# @exposes #logout to information disclosure with #brute
# @exposes #ac to information disclosure with #brute
# @exposes #auser to information disclosure with #brute
# @exposes #sql_server to information disclosure with #brute


@flask_app.route('/login', methods = ['POST','GET'])      #login page
def login_page():
    #need to render the login.html page
    return render_template('login.html')

@flask_app.route('/index')
def index2_page():
    #need to render the login.html page
    return render_template('index.html')

# @component CalcApp:Web_Server:Accountcreation (#ac)
# @connects #ac with #acd with HTTPs-POST
# @connects #login with #ac with HTTPs-POST
# @connects #guest to #ac with HTTPs-POST
# @connects #ac to #guest with HTTPs-POST

@flask_app.route('/addlogin', methods = ['POST'])
def addlogin_page():
    #need to render the login.html page
    return render_template('addlogin.html')

# @component CalcApp:Web_Server:Accountcreated (#acd)
# @connects #acd with #login with HTTPs-POST
# @connects #guest to #acd with HTTPs-POST
# @connects #acd to #guest with HTTPs-POST

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

# @component CalcApp:Web_Server:Authenticated (#auth)
# @connects #login to #auth with HTTPs-POST
# @connects #auth to #index with HTTPS-GET

# @connects #auser to #auth with HTTPs-POST
# @connects #auth to #auser with HTTPs-POST

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
        resp.set_cookie('token', user_token, max_age=606024*2, httponly=True, secure=True, samesite='Strict')
        return resp   #retreive data from the post from the login page
    else:
        return render_template('login.html')


@flask_app.route('/calculator', methods = ['GET','POST'])
def calculator_get():
    isUserLoggedIn = False
    if 'token' in request.cookies: #if there is a token in cookies return true
        isUserLoggedIn = verify_token(request.cookies['token'])
    if isUserLoggedIn:  #if there is a token go here
        return render_template('caltemplate.html')
    else:  # if no token in cookies go here
        resp = make_response(redirect('/login'))
        return resp

# @component CalcApp:Web_Server:Results (#results)

# @connects #results to #index with HTTPs-get
# @connects #index to #results with HTTPS-POST

# @connects #auser to #results with HTTPs-POST
# @connects #results to #auser with HTTPs-POST

@flask_app.route('/results', methods = ['POST']) #authpage get to here form login
def results_users():
    data = request.form   #retreive data from the post from the login page
    num1 = float(data['number1'])       # store username and password from html
    num2 = float(data['number2'])
    operation = request.form.get('operation')
    calculatorObject = cal.CalculatorClass(num1, num2)            #makes a calculator class object which contains number 1 and number 2

    #all operations
    ##result = calculatorObject.checklist()
    ##add,sub,mul,divide = result[2],result[3],result[4],result[5]                               #makes a list of results to use
    #resp = make_response(render_template('results.html', number1 = num1, number2 = num2, a = add,s = sub,m = mul,d = divide ))

    #singular operation
    resulting = calculatorObject.process(operation)
    resp = make_response(render_template('results2.html',number1 = num1, number2 = num2, operation =operation, result = resulting))

    return resp

@flask_app.route('/calculator2', methods = ['POST'])
def calculate2_post2():
    number_1 = request.form.get('number1', type = int)
    number_2 = request.form.get('number2', type = int)
    operation = request.form.get('operation')
    calculatorObject = cal.CalculatorClass(number_1, number_2)
    result = calculatorObject.process(operation)
    print(result)
    response_data = {
    'data' : result
    }
    return make_response(jsonify(response_data))
# @component CalcApp:Web_Server:logout (#logout)
# @connects #index to #logout with HTTPs-POST
# @connects #logout to #index with HTTPs-GET

# @connects #auser to #logout with HTTPs-GET
# @connects #logout to #auser with HTTPs-GET

@flask_app.route('/logout', methods = ['POST','GET'])
def logout():
    resp = make_response(render_template('login.html'))
    resp.delete_cookie('token', 'token')        #sets a cookie on the user attached to the response
    return resp

@flask_app.after_request
def apply_caching(response):
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
    response.headers['X-Content-Type-Options'] = "nosniff"
    return response
#-------------------------------------run server -------------------------------------------
if __name__ == "__main__":
    print("This is a secure calculator Server")
    flask_app.run(host = "0.0.0.0", debug = True, ssl_context=('cert/cert.pem','cert/key.pem'))   #runs the flask app so create a server debug =True means that it will auto update
