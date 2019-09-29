from datetime import datetime, timedelta

import app
from sqlalchemy import and_, desc, func, not_, or_
from model.content import Content
from model.content_post import ContentPost
from model.post import Post
from model.user import User
from model.vote import Vote


def get_posts(**kwargs):
    page = kwargs.get('page', 1)
    per_page = kwargs.get('per_page', 20)

    query = app.app.db.query(Post)
    query = query.filter(Post.parent_post_id == None)
    query = query.filter(Post.scheduled_date <= datetime.utcnow()).order_by(desc(Post.created_at))

    return query.offset((page - 1) * per_page).limit(per_page).all()


def get_posts_popular(**kwargs):
    page = kwargs.get('page', 1)
    per_page = kwargs.get('per_page', 20)

    query = app.app.db.query(Post, func.count(Post.votes).label("total"))
    query = query.filter(Post.parent_post_id == None)
    query = query.filter(Post.scheduled_date <= datetime.utcnow()).group_by(Post).order_by(desc('total'))
    return query.offset((page - 1) * per_page).limit(per_page).all()
