from sqlalchemy import Column, TIMESTAMP
import datetime
from sqlalchemy.ext.declarative import declarative_base


base = declarative_base()


class Base(base):
    __abstract__ = True

    created_at = Column(TIMESTAMP, default=datetime.datetime.utcnow)
    modified_at = Column(TIMESTAMP, onupdate=datetime.datetime.utcnow)
