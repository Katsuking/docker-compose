"""update model

Revision ID: ceb43befc3cd
Revises: fcd2d6b1a318
Create Date: 2023-05-12 22:00:34.524154

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ceb43befc3cd'
down_revision = 'fcd2d6b1a318'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('name', sa.String(length=30), nullable=True))
    op.create_index(op.f('ix_users_name'), 'users', ['name'], unique=False)
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_users_name'), table_name='users')
    op.drop_column('users', 'name')
    # ### end Alembic commands ###