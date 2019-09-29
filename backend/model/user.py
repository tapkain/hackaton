from . import base
import datetime
from sqlalchemy import Column, Integer, String, ForeignKey, JSON, Boolean, Text, TIMESTAMP
from sqlalchemy.dialects import postgresql
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry


class User(base.Base):
    __tablename__ = "user"

    id = Column(String(128), primary_key=True)
    latitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    longitude = Column(postgresql.DOUBLE_PRECISION, nullable=True)
    geo = Column(Geometry(geometry_type='POINT'))

    def __init__(self, data):
        self.id = data.get('id')
        self.latitude = data.get('latitude')
        self.longitude = data.get('longitude')
