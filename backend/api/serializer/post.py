from marshmallow import Schema, fields
from serializer.content import ContentSchema
from serializer.user import ReducedUserSchema
from serializer.vote import VoteSchema
from serializer.base import BaseSchema


class PostSchema(BaseSchema):
    featured = fields.Int()
    parent_post_id = fields.Int()
    user_id = fields.Str()
    description = fields.Str()
    location = fields.Str()
    ctv = fields.Float(attribute='content_total_value')
    content_size_bytes = fields.Float()

    user = fields.Nested(ReducedUserSchema)

    contents = fields.List(fields.Nested(ContentSchema))
