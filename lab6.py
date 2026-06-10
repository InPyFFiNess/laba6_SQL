from sqlalchemy.orm import Session
from sqlalchemy import Column, Date, Integer, String, Time, create_engine
from sqlalchemy.orm import DeclarativeBase
import secret as sec

database_url = f"mssql+pymssql://{sec.login}:{sec.password}@{sec.connect}/User_Actions"

engine0 = create_engine(database_url)
engine1 = create_engine(database_url)
engine2 = create_engine(database_url)
engine3 = create_engine(database_url)
engine4 = create_engine(database_url)
engine5 = create_engine(database_url)
engine6 = create_engine(database_url)
engine7 = create_engine(database_url)
engine8 = create_engine(database_url)
engine9 = create_engine(database_url)
engine10 = create_engine(database_url)
engine11 = create_engine(database_url)

class Base(DeclarativeBase):
    pass

class Logs(Base):
    __tablename__ = "Logs"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, nullable=False)
    user_action = Column(String, nullable=False)
    action_date = Column(Date, nullable=False)
    action_time = Column(Time, nullable=False)
    action_result = Column(String, nullable=False)

Base.metadata.create_all(bind=engine0)

def inputt(engine:str, input_data:Logs):
    with Session(autoflush=False, bind=engine) as db:
        db.add(input_data)
        db.commit()

def sendto_shard(input_data:Logs, memory:int):
    match memory:
        case 0:
            inputt(engine=engine0, input_data = input_data)
            print("bd0")
        case 1:
            inputt(engine=engine1, input_data = input_data)
            print("bd1")
        case 2:
            inputt(engine=engine2, input_data = input_data)
            print("bd2")
        case 3:
            inputt(engine=engine3, input_data = input_data)
            print("bd3")
        case 4:
            inputt(engine=engine4, input_data = input_data)
            print("bd4")
        case 5:
            inputt(engine=engine5, input_data = input_data)
            print("bd5")
        case 6:
            inputt(engine=engine6, input_data = input_data)
            print("bd6")
        case 7:
            inputt(engine=engine7, input_data = input_data)
            print("bd7")
        case 8:
            inputt(engine=engine8, input_data = input_data)
            print("bd8")
        case 9:
            inputt(engine=engine9, input_data = input_data)
            print("bd9")
        case 10:
            inputt(engine=engine10, input_data = input_data)
            print("bd10")
        case 11:
            inputt(engine=engine11, input_data = input_data)
            print("bd11")
    return (memory + 1) % 12


def main():
    input_data = Logs(username = "admin", user_action = "LOGIN", action_date = "2023-01-01", action_time = "00:00:00", action_result = "SUCCESS")
    memory = 0
    for i in range(0, 11):
        memory = sendto_shard(input_data, memory=memory)

if __name__ == "__main__":
    main()