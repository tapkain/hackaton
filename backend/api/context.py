import os
from contextlib import contextmanager


class Context:
    def __init__(self):
        self.db = ''
        self.initialized = False

app = Context()


def create(db=False):
    print(os.environ.get('DATABASE_URL'))

    if app.initialized:
        return app

    if db:
        from sqlalchemy.orm import sessionmaker
        from sqlalchemy import create_engine
        from sqlalchemy.pool import NullPool
        app.engine = create_engine(os.getenv('DATABASE_URL'), poolclass=NullPool, echo=True)
        Session = sessionmaker(bind=app.engine)
        app.db = Session()

    app.initialized = True
    return app
