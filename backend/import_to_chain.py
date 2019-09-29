import subprocess
import pexpect
import sys
from model import Vote, Post, Content, User
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool
import os

engine = create_engine(os.getenv('DATABASE_URL'), poolclass=NullPool)
Session = sessionmaker(bind=engine)
db = Session()

def get_votes(**kwargs):
    page = kwargs.get('page', 1)
    per_page = kwargs.get('per_page', 20)

    query = db.query(Vote).with_entities(Vote.id, Vote.post_id, Content.hash, Content.mime, Vote.vote, User.latitude, User.longitude).join(Post.votes).join(Post.contents).join(Vote.user_id)
    return query.offset((page - 1) * per_page).limit(per_page).all()

#child = pexpect.spawn("su")
#child.logfile_read = sys.stdout
#subprocess.call(['cleos', 'wallet', 'open'])
#subprocess.call(['cleos', 'wallet', 'unlock'])

posts = get_votes(per_page=10)
print(len(posts))
print(posts[0])

db.close()
engine.dispose()