from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def main():
    return {"Hello": "World"}


# az ad sp create-for-rbac --name fastapi-appsvc --role contributor --scopes /subscriptions/e5c6d7a1-acbb-4854-b6ed-4ca43a989abc
