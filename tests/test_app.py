import pytest
from src.app import app

@pytest.fixture
def client():
    # Dit maakt een test-omgeving voor onze Flask-app
    with app.test_client() as client:
        yield client

def test_home_page(client):
    # De robot doet een nep-bezoekje aan de homepagina
    response = client.get('/')
    # We checken of we een HTTP 200 (OK) terugkrijgen
    assert response.status_code == 200
    # En of de juiste tekst op het scherm staat
    assert b"Hello van de Azure Container App!" in response.data