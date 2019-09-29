from marshmallow import Schema, fields
from serializer.base import BaseSchema


class VoteSchema(BaseSchema):
    user_id = fields.Str()
    post_id = fields.Int()
    vote = fields.Int()
    ivr = fields.Float()
