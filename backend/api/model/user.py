from . import base
import datetime
from sqlalchemy import Column, Integer, String, ForeignKey, JSON, Boolean, Text, TIMESTAMP
from sqlalchemy.dialects import postgresql
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from .vote import Vote
from .post import Post


class User(base.Base):
    __tablename__ = "user"

    id = Column(String(128), primary_key=True)
    email = Column(String(255), unique=True)
    username = Column(String(255), unique=True)
    new_power = Column(postgresql.DOUBLE_PRECISION, nullable=False)
    content_power = Column(postgresql.DOUBLE_PRECISION, nullable=False)
    vote_power = Column(postgresql.DOUBLE_PRECISION, nullable=False)
    network_power = Column(postgresql.DOUBLE_PRECISION, nullable=False)
    powerx = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    new_coins = Column(Integer, nullable=False)
    life_level = Column(Integer, nullable=False)

    invited_by = Column(
        String(128), ForeignKey('user.id'))
    invite_code = Column(String(255))

    social = Column(JSON())
    bio = Column(Text)

    picture_path = Column(String(255))
    referenced_from = Column(String(255))
    confirmed = Column(Boolean, nullable=False)

    latitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    longitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    last_online_at = Column(TIMESTAMP)
    role = Column(String(255), server_default='user', default='user', nullable=False)
    geo = Column(Geometry(geometry_type='POINT'))

    # votes = relationship('Vote', backref='user', lazy='dynamic', cascade="all, delete-orphan")
    posts = relationship('Post', cascade="all, delete-orphan")
    invitor = relationship('User', remote_side=[id], uselist=False)
    invited_users = relationship('User', remote_side=[invited_by])

    def __init__(self, data):
        self.id = data.get('id')
        self.email = data.get('email')
        self.username = data.get('username')
        self.vote_power = data.get('vote_power', 0)
        self.new_power = data.get('new_power', 0)
        self.network_power = data.get('network_power', 0)
        self.content_power = data.get('content_power', 0)
        self.new_coins = data.get('new_coins', 0)
        self.life_level = data.get('life_level', 0)
        self.invited_by = data.get('invited_by')
        self.invite_code = data.get('invite_code')
        self.social = data.get('social')
        self.bio = data.get('bio')
        self.picture_path = data.get('picture_path')
        self.referenced_from = data.get('referenced_from')
        self.confirmed = data.get('confirmed', False)
        self.last_online_at = data.get('last_online_at', datetime.datetime.utcnow())
        self.created_at = data.get('created_at', datetime.datetime.utcnow())
        self.role = data.get('role', 'user')
        self.latitude = data.get('latitude')
        self.longitude = data.get('longitude')
