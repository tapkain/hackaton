from sqlalchemy import Column, Integer, ForeignKey
from . import base


class ContentPost(base.Base):
    __tablename__ = "content_post"

    id = Column(Integer, primary_key=True, autoincrement=True)
    post_id = Column(Integer, ForeignKey('post.id'), nullable=False)
    content_id = Column(Integer, ForeignKey('content.id'), nullable=False)
