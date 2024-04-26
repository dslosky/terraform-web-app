from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hellooooo everybody!"}

@app.get("/test")
def test():
    return {
        'status': 200,
        'data': {
            'here': 'it is!'
        }
    }
