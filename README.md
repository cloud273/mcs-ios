# Content

- This repository includes coding for both Patient and Doctor application

- Patient can install demo app via https://testflight.apple.com/join/65qySFEb

- Doctor can install demo app via https://testflight.apple.com/join/Gs69j8P5


# Patient app

1. Account: Each patient has've got an account. He/she can manage their profile, health information, appointment
    - Create account using email
    - Update patient profile (name, date of birth, address, image ...)
    - Update and forgot password
    
2. Health information: Patient can update his/her health information and he/she can share them to doctor when create an booking
    - Create/update patient's allergy information
    - Create/update patient's surgery information
    - Update patient's medication information (High blood pressure?, High cholesterol?, Pregnant?)
    
3. Booking an appointment: Patient books an appointment with doctor
    - Select specialty
    - Search for doctor
    - Get booking fee
    - Select booking time
    - Cancel a booking
    - Notification for status of appoinment (Accepted/ Rejected/ Begun/ Finished)
    
4. History of appointments
    - List of appointment
    - Detail of an appointment


# Doctor app

1. Account: A clinic has many doctor. Each doctor has account, he need to use account to login
    - Login
    - Update and forgot password

2. Appointment
    - List of all upcomming appointments
    - List of today appointment
    - Show all patient information/ symptom/ medication / allergy/ surgery that patient shared in appointment
    - Begin/ Finish an appointment
    - Notification for new verified appointment
    
3. History of appointments
    - List of appointment in a month
    - Detail of an old appointment
    
4. More information
    - Schedule of doctor
    - Package of doctor
    
    
# Note

- Doctor can't create account via application. When a clinic register with MCS system, MCS system admin will create an clinic admin account and accounts for doctors of clinic.
- Clinic admin will using web (http://mcs.cloud273.com) to login and manage appointment and other information
- Clinic admin will register schedule for doctor via web admin
- When patient create appointment, it must be verified by clinic admin before doctor can get it.


# Todo

- Telemedicine and presciption
- Summary for doctor


# Development

1. Git

    + `git clone --recurse-submodules https://cloud273.com:8027/mcs/ios.git`
    + `git pull --recurse-submodules`
    
2. Submodule

    + Add:  `git submodule add https://cloud273.com:8027/library/ios-core.git`
    + Add:  `git submodule add https://cloud273.com:8027/library/ios-localization.git`
    + Add:  `git submodule add https://cloud273.com:8027/library/ios-whiteLabel.git`
    
    +  Remove: 
        - `git submodule deinit <path_to_submodule>`
        - `git rm <path_to_submodule>`
        - `git commit-m "Removed submodule "`
        - `rm -rf .git/modules/<path_to_submodule>`

    + Update
        - `git pull origin HEAD:master`
        - `git push origin HEAD:master`


2. Convert p12 to pem to read information

    + `openssl pkcs12 -in doctor.p12 -out doctor.pem -nodes -clcerts`
    + `openssl pkcs12 -in patient.p12 -out patient.pem -nodes -clcerts`

