# Generated by Django 2.0.7 on 2019-06-04 15:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('events', '0003_exceluploadlog'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='transportationpickuplocation',
            name='event',
        ),
        migrations.RemoveField(
            model_name='transportationpickuplocation',
            name='event_item',
        ),
        migrations.AlterField(
            model_name='exceluploadlog',
            name='type',
            field=models.CharField(choices=[('Accommodation-Room-Allocation', 'Accommodation-Room-Allocation'), ('Accommodation-Room-Creation', 'Accommodation-Room-Creation')], max_length=255),
        ),
    ]
