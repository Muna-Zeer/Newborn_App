# Newborn_App

+--------------+     1     +-----------------+     1     +--------------+
|     Users    |------------| MinistryOfHealth|------------|HealthCenters |
+--------------+            +-----------------+            +--------------+
| user_id      |            | ministry_id     |            | hc_id        |
| name         |            | name            |            | name         |
| email        |            | contact_info    |            | address      |
| password     |            | website         |            | contact_info |
| role         |                                               | doctors      |
+--------------+                                               | nurses       |
                                                                +--------------+
                           1           *            1            *
+--------------+     1     +---------------+     *     +--------------+
|    Mothers   |------------|    Newborns   |-----------|   Hospitals  |
+--------------+            +---------------+           +--------------+
| mother_id    |            | newborn_id    |           | hospital_id |
| name         |            | name          |           | name        |
| date_of_birth|            | date_of_birth|           | address     |
| contact_info |            | gender        |           | contact_info|
| medical_hist |            | birth_weight |           | doctors     |
+--------------+            | hospital_id  |           | nurses      |
                             +---------------+           +--------------+

                           1           *             1            *
+--------------+     1     +---------------+     +---------------+
|Vaccinations  |------------| Appointments  |-----| Notifications |
+--------------+            +---------------+     +---------------+
| vaccine_id   |            | appt_id       |     | notif_id      |
| vaccine_name |            | date_time     |     | type          |
| date_given  |            | notes         |     | recipient     |
| adverse_reac |                                    | date_time     |
+--------------+                                    +---------------+

                            1           *             1            *
+--------------+     1     +---------------+     +---------------+
|   Feeding    |------------| PreventiveEx  |-----|  Healthcare   |
+--------------+            +---------------+     +---------------+
| feeding_id   |            | prevent_id    |     | hc_id         |
| feeding_type |            | type          |     | warning       |
| date_time    |            | date_time     |     | instructions  |
| amount       |            | notes         |     +---------------+
+--------------+
