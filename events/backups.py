from django.db import migrations


def create_configurations(apps, schema_editor):
    Configuration = apps.get_model('events', 'Configuration')
    data = [
        {'key': 'contact_number_first', 'value': '+977 9876543210'},
        {'key': 'contact_number_second', 'value': '+977 0123456789'},
        {'key': 'contact_email', 'value': 'amaroo@gmail.com'},
        {'key': 'facebook_link', 'value': 'www.facebook.com'},
        {'key': 'instagram_link', 'value': 'www.instagram.com'},
        {'key': 'youtube_link', 'value': 'www.youtube.com'},
        {'key': 'linkedin_link', 'value': 'www.linkedin.com'},
        {'key': 'copyright_content', 'value': 'hello hello '},
        {'key': 'powered_by', 'value': 'Nipuna Prabidhik sewa'},
        {'key': 'footer_description', 'value': 'footer footer '},
        {'key': 'nipuna_website_link', 'value': 'www.nipunaprabidhik.net/'}

    ]
    for each in data:
        Configuration.objects.get_or_create(key=each['key'], value=each['value'])


def initial_data_migrations(apps, schema_editor):
    # We can't import the Person model directly as it may be a newer
    # version than this migration expects. We use the historical version.
    create_configurations(apps, schema_editor)


class Migration(migrations.Migration):
    dependencies = [
        ('events', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(initial_data_migrations),
    ]
