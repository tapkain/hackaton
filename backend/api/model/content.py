from sqlalchemy import Column, Integer, String, JSON
from . import base


class Content(base.Base):
    __tablename__ = "content"

    id = Column(Integer, primary_key=True, autoincrement=True)
    hash = Column(String(32), unique=True, nullable=False)
    filename = Column(String(255))
    meta = Column(JSON(), nullable=True)
    mime = Column(String(50))
    size = Column(Integer)

    def __init__(self, data):
        self.hash = data.get('hash')
        self.filename = data.get('filename')
        self.meta = data.get('meta')
        self.mime = data.get('mime')
        self.size = data.get('size')
