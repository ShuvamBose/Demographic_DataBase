import mysql.connector as mysql
import socket
import time
from os import system, name
import  sys

def clear():
    # for windows
    if name == 'nt':
        _ = system('cls')
    # for linux
    else:
        _ = system('clear')

db=mysql.connect(
    host="localhost",
    username="root",
    database="demographic_db"
    )
    
print("connected to: ",db.get_server_info())
mycursor= db.cursor()

def preexisting(id):
    id=(int(id),)
    mycursor.execute('SELECT id FROM user')
    data=(mycursor.fetchall())
    if id in data:
        return 0
    return 1
    

def add_data(id,name,state,phone,dob,sex):
    if(preexisting(id)):
        mycursor.execute('INSERT INTO user VALUES(%s,%s,%s,%s)',(id,name,state,phone))
        db.commit()
        mycursor.execute('INSERT INTO gender VALUES(%s,%s)',(id,sex))
        db.commit()
        mycursor.execute('INSERT INTO age VALUES(%s,%s)',(id,dob))
        db.commit()
        print("Successfully Inserted.")
    else:
        print("Id already exists\n")
        print("Enter new ID:")
        id=int(input())
        add_data(id,name,state,phone,dob,sex)
        #func call

def modify_user_data(id):
    print("Enter what you want to update:\t")
    print("1.Name\n2.State\n3.Phone\n4.Sex\n5.dob")
    n=int(input())
    if n==1:
        print("Enter name: ",end='')
        new_name=input()
        mycursor.execute("UPDATE user SET name=%s WHERE id=%s ", (new_name,id))
        db.commit()
        print("Successfully Updated")
    if n==2:
        print("Enter State: ",end='')
        new_state=input()
        mycursor.execute("UPDATE user SET state=%s WHERE id=%s ", (new_state,id))
        db.commit()
        print("Successfully Updated")
    if n==3:
        print("Enter Phone: ",end='')
        new_phone=input()
        mycursor.execute("UPDATE user SET phone=%s WHERE id=%s ", (new_phone,id))
        db.commit()
        print("Successfully Updated")
    if n==4:
        print("Enter Sex: ",end='')
        new_sex=input()
        mycursor.execute("UPDATE gender SET sex=%s WHERE id=%s ", (new_sex,id))
        db.commit()
        print("Successfully Updated")
    if n==5:
        print("Enter dob: yyyy-mm-dd ",end='')
        new_dob=input()
        mycursor.execute("UPDATE age SET dob=%s WHERE id=%s ", (new_dob,id))
        db.commit()
        print("Successfully Updated")
    if n not in [1,2,3,4,5]:
        print("Enter correct no. from above next time !!\nTRY AGAIN")
    
def user_getter(id):
    id=[id]
    mycursor.execute('SELECT * FROM user WHERE id=%s',id)
    #db.commit()
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")
    #return data
 
def age_getter(id):
    id=[id]
    mycursor.execute('SELECT user.id,user.name,age_cal(age.id) FROM user,age WHERE age.id=%s AND age.id=user.id',id)
    
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")
    #return data 

def sex_getter(id):
    id=[id]
    mycursor.execute('SELECT user.id,user.name,gender.sex FROM user,gender WHERE gender.id=%s AND gender.id=user.id',id)
    
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")
    #return data

def wanted_getter(id):
    id=[id]
    mycursor.execute('SELECT user.id,user.name,wanted.wanted_status FROM user,wanted WHERE wanted.id=%s AND wanted.id=user.id',id)
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")
    
def nri_getter(id):
    id=[id]
    mycursor.execute('SELECT user.id,user.name,nri.nri_status FROM user,nri WHERE nri.id=%s AND nri.id=user.id',id)
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")

def passport_getter(id):
    id=[id]
    mycursor.execute('SELECT * FROM passport WHERE passport.id=%s',id)
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")

def bank_getter(id):
    id=[id]
    mycursor.execute('SELECT * FROM banks WHERE banks.id=%s',id)
    data=(mycursor.fetchall())
    print("\n")
    for i in data:
        print(i)
    print("\n")

def del_data(id):
    mycursor.execute('SET FOREIGN_KEY_CHECKS=0')
    db.commit()
    mycursor.execute('DELETE FROM user WHERE id="{}"'.format(id))
    db.commit()
    mycursor.execute('DELETE FROM age WHERE id="{}"'.format(id))
    db.commit()
    mycursor.execute('DELETE FROM gender WHERE id="{}"'.format(id))
    db.commit()
    mycursor.execute('SET FOREIGN_KEY_CHECKS=1')
    db.commit()
    print("Successfully Deleted !")

def genericQuery():
    print("Enter your desired valid query without \';\' :")
    vv=input()
    try:
        mycursor.execute('{}'.format(vv))
        #db.commit()
        data=(mycursor.fetchall())
        print("\n")
        for i in data:
            print(i)
        print("\n")
    except:
        print("\n\tERROR:")
        for i in sys.exc_info():
            print(i)
        print("\n")

def dispList():
    print("a.All records\tb.Age\nc.Gender\td.User\ne.NRI\t\tf.Wanted\ng.Passport\th.Bank")

def dispJunc(j):
    
    if j=='a':
        mycursor.execute('SELECT user.id,user.name,gender.sex,age_cal(user.id),user.state,user.phone FROM user,gender WHERE user.id=gender.id')
        data=(mycursor.fetchall())
        print("\n")
        for i in data:
            print(i)
        print("\n")
    if j=='b':
        print("Enter ID:")
        id=int(input())
        age_getter(id)
    if j=='c':
        print("Enter ID:")
        id=int(input())
        sex_getter(id)
    if j=='d':
        print("Enter ID:")
        id=int(input())
        user_getter(id)
    if j=='e':
        print("Enter ID:")
        id=int(input())
        nri_getter(id)
    if j=='f':
        print("Enter ID:")
        id=int(input())
        wanted_getter(id)
    if j=='g':
        print("Enter ID:")
        id=int(input())
        passport_getter(id)
    if j=='h':
        print("Enter ID:")
        id=int(input())
        bank_getter(id)
        
        
def initialWindow():
    clear()
    print("\t\tDemographic DataBase Management System")
    print("\t\tSRN: PES2UG20CS335")
    print("\t\tName: SHUVAM BOSE")
    time.sleep(1)
    print("\n")
    menuOptions()
    
def menuOptions():
    print("1.Insert new record\t2.Update existing record\n3.Delete record\t\t4.Display record\n5.Enter Query\t\t6.Exit")
    print("Enter your choice:  ",end='')
    nn=int(input())
    
    if nn==1:
        print("Enter Id: ",end='')
        id=input()
        print("Enter Name: ",end='')
        name=input()
        print("Enter State: ",end='')
        state=input()
        print("Enter Phone: ",end='')
        phone=input()
        print("Enter Sex: ",end='')
        sex=input()		
        print("Enter DOB: yyyy-mm-dd ",end='')
        dob=input()   
        add_data(id,name,state,phone,dob,sex)
    if nn==2:
        print("Enter Id: ",end='')
        id=input()
        if 0==preexisting(id):
            modify_user_data(id)
        else:
            print("No matching ID found !")
        
    if nn==3:
        print("Enter Id: ",end='')
        id=input()
        if 0==preexisting(id):
            del_data(id)
        else:
            print("\n")
            print("No matching ID found !\n")
  
    if nn==4:
        dispList()
        x=(input())
        if x not in ['a','b','c','d','e','f','g','h']:
            print("Enter correct option !")
        else:
            dispJunc(x)
    
    if nn==6:
        mycursor.close()
        db.close()
        print("We are closing .\nPLEASE WAIT...")
        time.sleep(3)
        clear()
        quit()
    
    if nn==5:
        genericQuery()
    
    if nn not in range(1,6):
        print("Out of bound option choosen !!")
        print("Try again")
        menuOptions()
    
    menuOptions()   
        
        
initialWindow()