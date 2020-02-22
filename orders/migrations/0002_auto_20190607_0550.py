# Generated by Django 2.0.7 on 2019-06-07 05:50

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0006_transportationpickuplocation_event'),
        ('orders', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='ordereditem',
            name='event',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='events.Event'),
        ),
        migrations.AddField(
            model_name='ordereditem',
            name='event_registration_type',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='events.EventRegistrationType'),
        ),
    ]