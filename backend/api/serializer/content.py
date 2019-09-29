from marshmallow import Schema, fields
from serializer.base import BaseSchema, GenesisSchema


class ContentSchema(GenesisSchema):
    hash = fields.Str()
    user_id = fields.Str()
    mime = fields.Str()

    thumbnail_width = fields.Function(
        lambda obj: int(obj.meta['thumbnail_width']) if obj and obj.meta and obj.meta.get('thumbnail_width',
                                                                                          None) else None)
    thumbnail_height = fields.Function(
        lambda obj: int(obj.meta['thumbnail_height']) if obj and obj.meta and obj.meta.get('thumbnail_height',
                                                                                           None) else None)
