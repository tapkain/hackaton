import datetime
from sqlalchemy import Column, Integer, String, ForeignKey, SmallInteger,  Text, TIMESTAMP
from . import base
from sqlalchemy.dialects import postgresql
from sqlalchemy.orm import relationship
from .content import Content
from .content_post import ContentPost
from .vote import Vote


class Post(base.Base):
    __tablename__ = "post"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(128), ForeignKey('user.id'), nullable=False)
    parent_post_id = Column(Integer, ForeignKey(id), nullable=True)
    
    description = Column(Text)
    location = Column(String(255), nullable=True)
    latitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    longitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    featured = Column(SmallInteger, nullable=True)
    content_total_value = Column(postgresql.DOUBLE_PRECISION, nullable=False, default=0.0)
    scheduled_date = Column(TIMESTAMP, nullable=True)

    user = relationship("User", foreign_keys=[user_id], lazy='joined')
    parent = relationship("Post", remote_side=[id], lazy='joined')
    childs = relationship('Post', remote_side=[parent_post_id], cascade="all, delete-orphan", lazy='joined')
    contents = relationship('Content', secondary='content_post', backref='posts', lazy='joined')
    votes = relationship('Vote', backref='post', lazy='dynamic', cascade="all, delete-orphan")

    def __init__(self, data):
        self.id = data.get('id')
        self.user_id = data.get('user_id')
        self.parent_post_id = data.get('parent_post_id')
        self.description = data.get('description')
        self.location = data.get('location')
        self.latitude = data.get('latitude')
        self.longitude = data.get('longitude')
        self.featured = data.get('featured', None)
        self.content_total_value = data.get('content_total_value', 0)
        self.created_at = data.get('created_at', datetime.datetime.utcnow())
        self.scheduled_date = data.get('scheduled_date', None)

