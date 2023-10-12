# Smart Health Companion iOS Application
An iOS application that uses the device camera and motion sensors to measure the user's heart and respiratory rates. Additionally, the application allows users to record any symptoms they are feeling.

> **Disclaimer** The algorithms used to measure the user's vitals, such as heart and respiratory rates, are solely for demonstration and should not be used in practical use cases.

## Application Features
Apart from the two primary objectives of measuring the user's vitals, the application offers symptom recording and card visualization of historical records, as discussed in further sections.

### Dashboard
The application's homepage or dashboard presents the heart and respiratory rates of the user at that time. The application uses default values for this session since the user has not measured any of these vitals on startup.

![Dashboard's Screenshot](/mockups/1.png "Dashboard's Screenshot")

### Heart Rate Measurement
Once the user clicks on the button with the heart icon, the user moves to the heart rate measurement screen, which prompts the user to gently place their index finger on the camera lens and start measuring their heart rate.

![Heart Rate Measurement Start Screenshot](/mockups/2.png "Heart Rate Measurement Start Screenshot")

After pressing the 'Start Measuring' button, the application records a 45-second-long video to measure their heart rate.

![Heart Rate Measurement Recording Screenshot](/mockups/3.png "Heart Rate Measurement Recording Screenshot")

Post video recording, the application processes this recording and measures the user's heart rate using a trivial algorithm.

![Heart Rate Measurement Processing Screenshot](/mockups/4.png "Heart Rate Measurement Processing Screenshot")

After measuring the heart rate, the application redirects the user back to the dashboard, where the user can check the calculated heart rate.

![Heart Rate Measurement Completed Screenshot](/mockups/5.png "Heart Rate Measurement Completed Screenshot")

### Respiratory Rate Measurement
Once the user clicks on the button with the lungs icon, the application greets the user with a prompt with instructions to measure the user's respiratory rate.

![Respiratory Rate Instructions Screenshot](/mockups/6.png "Respiratory Rate Instructions Screenshot")

After clicking on the 'Start Measuring' button on the prompt, the application measures the user's respiratory rate using a trivial algorithm utilizing the device's motion sensors.

![Respiratory Rate Measuring Screenshot](/mockups/7.png "Respiratory Rate Measuring Screenshot")

Once the application completes the 45-second-long respiratory rate measurement, it updates the dashboard with the newly calculated respiratory rate.

![Respiratory Rate Completed Screenshot](/mockups/8.png "Respiratory Rate Completed Screenshot")

### Symptoms
After the user clicks on the plus icon on the top right corner of the dashboard, the application presents the symptom recording screen, where the user can submit any symptom they are feeling.

![Symptoms Screenshot](/mockups/9.png "Symptoms Screenshot")

Users can select from a predefined list of symptoms the application presents and record its severity.

![Symptoms List Screenshot](/mockups/10.png "Symptoms List Screenshot")

### History
The application allows users to view their measurements in past sessions by clicking on the button with the clock icon on the top right corner of the dashboard.

![History Screenshot](/mockups/11.png "History Screenshot")

Once any session is selected, the application presents the recorded information as a card.

![History Card Screenshot](/mockups/12.png "History Card Screenshot")

Additionally, the application allows the user to share this card with anyone as an image using the 'Share Summary' button.

![History Card Share Screenshot](/mockups/13.png "History Card Share Screenshot")

## Debugging Tips
- Once the application starts, you will see `sqlite` file path in the logs, if _developer mode_ is _enabled_ in the Settings app.
- Navigate to the said path, and run `open -a DB\ Browser\ for\ SQLite ./HeartRespSensor.sqlite` command to open [DB Browser](https://sqlitebrowser.org/).
