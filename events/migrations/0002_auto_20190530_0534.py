# Generated by Django 2.0.7 on 2019-05-30 05:34

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='accommodationroom',
            name='event_attendee',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='events.EventAttendee'),
        ),
    ]
