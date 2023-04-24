
from pydantic import BaseSettings, validator
from mysql.dsn import MySQLDsn

class Settings(BaseSettings):
    """ デフォルト設定。環境変数ファイル: .env あくまでこんな感じで書くよって話 """
    app_name: str = "My App"
    debug: bool = False

    MYSQL_SERVER: str
    MYSQL_USER: str
    MYSQL_PASSWORD: str
    MYSQL_DB: str
    SQLALCHEMY_DATABASE_URI: MySQLDsn = None

    @validator("SQLALCHEMY_DATABASE_URI", pre=True)
    def assemble_db_connection(cls, v, values):
        if isinstance(v, str):
            return v
        return MySQLDsn.build(
            scheme="mysql",
            user=values.get("MYSQL_USER"),
            password=values.get("MYSQL_PASSWORD"),
            host=values.get("MYSQL_SERVER"),
            path=f"/{values.get('MYSQL_DB') or ''}",
        )

    class Config:
        env_file = ".env" #環境変数ファイル

settings = Settings() # インスタンス作成
print(settings.app_name)