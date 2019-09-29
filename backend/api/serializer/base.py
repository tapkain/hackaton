from marshmallow import Schema, fields, post_dump
from marshmallow.utils import EXCLUDE
from datetime import datetime


class Timestamp(fields.Field):
    def _serialize(self, value, attr, obj, **kwargs):
        if value is None:
            return None
        if isinstance(value, str):
            return value
        return value.strftime('%Y-%m-%dT%H:%M:%S.%f')

    def _deserialize(self, value, attr, data, **kwargs):
        return datetime.strptime(value, '%Y-%m-%dT%H:%M:%S.%f')


class GenesisSchema(Schema):
    class Meta:
        unknown = EXCLUDE
        ordered = True

    SKIP_VALUES = [None, [], {}, '']

    @post_dump(pass_many=False)
    def remove_skip_values(self, data, **kwargs):
        return {
            key: value for key, value in data.items()
            if value not in self.SKIP_VALUES
        }


class BaseSchema(GenesisSchema):
    id = fields.Int()
    created_at = fields.DateTime(format='iso')
    modified_at = fields.DateTime(format='iso')

