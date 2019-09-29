import re

from marshmallow import Schema, fields, ValidationError
from marshmallow.utils import EXCLUDE


class BaseRequestSchema(Schema):
    class Meta:
        unknown = EXCLUDE


class PaginationRequestSchema(BaseRequestSchema):
    page = fields.Int()
    per_page = fields.Int()

