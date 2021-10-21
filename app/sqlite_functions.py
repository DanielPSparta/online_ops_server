import sqlite3
from contextlib import closing

def make_table():
    try:
        with closing(sqlite3.connect("data.db")) as connection:
            with closing(connection.cursor()) as cursor:
                cursor.execute("CREATE TABLE user_db (id INTEGER PRIMARY KEY, username TEXT, password TEXT);")
                connection.commit()
    except Exception as e:
        print("table already made")


def table_insert(user,password):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("INSERT INTO user_db (username, password) VALUES (?,?);", (str(user), str(password),))
            connection.commit()

def show_results():
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("SELECT * FROM user_db;")
            records = cursor.fetchall()
            print(records)
            for item in records:

                print(item)

def check_user_in_db(user,password):


    conn = sqlite3.connect('data.db')
    x = conn.execute("SELECT * FROM user_db WHERE username = ?", (str(user),)).fetchone()
    if x:
        print("username found")
        print(x)

        if conn.execute("SELECT * FROM user_db WHERE username = ? AND password = ?", (str(user), str(password),)).fetchone():
            print("Username and password match found")
            return True
        else:
            print("no password match")
            return False
    else:
        print("No username found")
        return False

def check_username_in_db(user,password):

    conn = sqlite3.connect('data.db')

    x = conn.execute("SELECT * FROM user_db WHERE username = ?", (str(user),)).fetchone()
    if x:
        print("user already has this name")
        return True
    else:
        print("No previous username found")
        return False


if __name__ == '__main__':
    make_table()

    #table_insert('Daniel','Password123')
    #show_results()
    check_user_in_db('john','monkey')
