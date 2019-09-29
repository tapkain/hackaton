import datetime

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.dialects import postgresql
from sqlalchemy.orm import relationship

from . import base


class Vote(base.Base):
    __tablename__ = "vote"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(128), ForeignKey('user.id'), nullable=False)
    post_id = Column(Integer, ForeignKey('post.id'), nullable=False)

    # number from 0 (deep dislike) to 20 (deep like)
    vote = Column(Integer, nullable=False)
    vote_power = Column(postgresql.DOUBLE_PRECISION, nullable=False)
    ivr = Column(postgresql.DOUBLE_PRECISION, nullable=False, default=0, server_default='0')

    def __init__(self, data):
        self.user_id = data.get('user_id')
        self.post_id = data.get('post_id')
        self.vote = data.get('vote', 0)
        self.vote_power = data.get('vote_power', 0)
        self.ivr = data.get('ivr', 0)
        self.created_at = data.get('created_at', datetime.datetime.utcnow())
