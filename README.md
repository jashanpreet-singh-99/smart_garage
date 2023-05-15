# smart_garage

![img](https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/Screenshot%202023-05-15%20at%2011.39.21%20AM.png)

## Overview

The Automated Garage System is a cutting-edge solution designed to provide users with seamless remote monitoring and control capabilities for their garage system. Leveraging the power of IoT devices and a robust cloud platform, this advanced system offers a highly convenient and secure user experience.

At the heart of this system lies a Flask API, which serves as the communication bridge between the remote client-side application and the garage controlling system. The Flask API enables seamless data transmission and facilitates real-time control and monitoring of the garage system from a user's mobile devices.

To enhance the user experience and provide an immersive demonstration, a state-of-the-art 3D Simulator has been developed. This simulator faithfully replicates the real-life garage system, allowing users to interact with a virtual representation of their garage environment. Through the simulator, users can visualize and simulate various scenarios, such as opening and closing the garage door, activating security features, and monitoring the status of the system.

The integration of IoT devices and cloud technology ensures that the Automated Garage System operates reliably and securely. Users can remotely access their garage system from anywhere, at any time, through a user-friendly mobile application. With the ability to monitor and control their garage system with ease, users gain peace of mind, convenience, and enhanced security for their valuable assets.

The combination of the Flask API, cloud platform, and 3D Simulator showcases the capabilities and potential of this innovative garage system. Its user-centric design and advanced features make it a reliable and future-proof solution for modern homeowners seeking efficient and intelligent control over their garage systems.

## Design

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/Picture1.png" width=300 align="center" alt="design"/>

## Features

* Control and Monitor Garage Door
* Control and Monitor Garage Lighting
* Monitor CO level in Garage
* Guest Access
* Vehicle Maintenance and Reminder System

## Control and Monitor Garage Door

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/Door.png" width="300" align="center" alt="door"/>

Once the user has successfully logged into their account, they gain the ability to conveniently operate their garage door through a user-friendly interface. The interface presents the user with intuitive buttons for both opening and closing the door, ensuring seamless control over the door's movements.

With utmost priority given to safety, the user is empowered with the capability to pause the door at any point during its opening or closing cycle. This important feature comes into play when the user detects the presence of an object in close proximity to the door, mitigating potential hazards and safeguarding both people and property.

To enhance the user experience further, the system provides a synchronized animation of the door's operation in real-time. This valuable feature allows users to observe the door's movements virtually, providing them with visual feedback that corresponds precisely with the physical actions of the garage door. Consequently, users can remotely monitor the door's opening progress and ensure a smooth operation, all from the convenience of their office or any location with an internet connection.

This advanced functionality proves particularly beneficial when users need to grant access to their garage for various purposes, such as welcoming new workers or receiving deliveries from online purchases. By simply activating the door remotely, users can facilitate the entry of authorized personnel or conveniently receive deliveries from e-commerce platforms, providing a seamless and secure experience for all parties involved.

Overall, this comprehensive system delivers a professional and user-centric solution, integrating safety measures, real-time animation, and remote control capabilities to offer users an unparalleled level of convenience, security, and control over their garage door operations.
As per user requirement, lights in the garage and driveway can be controlled using mobile application.

## Control and Monitor Garage Lighting

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/Lights'.png" width="300" align="center" alt="light"/>

The utilization of this application offers a secure and efficient solution to the potential risks and hazards associated with entering a dark room, particularly in scenarios such as garages. By granting users the capability to remotely operate the lighting system, it empowers them with the freedom to enter their garages safely. This remote control functionality becomes particularly valuable when considering situations where users may have cameras installed within their garages. Oftentimes, due to nighttime or low-light conditions, clear and accurate visual communication becomes challenging. However, with the ability to remotely activate the lights through the application, users can enhance visibility within the garage, facilitating improved clarity and ensuring a safer environment.

The application further enhances convenience by enabling users to individually control each light source, providing them with the flexibility to achieve the optimal brightness level that suits their specific needs. By offering seamless remote access and control over the lighting system, this application ensures that users can effectively and effortlessly illuminate their garages, thereby mitigating potential risks and enhancing overall security.

## Monitor CO level in Garage

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/CO%20levels.png"  width="300" align="center" alt="co"/>

Carbon monoxide (CO) poses significant health risks to humans, especially in enclosed spaces such as a garage. Prolonged exposure to elevated levels of CO can have severe consequences for individuals. When an individual idles a car in a garage, toxic gases, including CO, can accumulate, leading to potential harm over time.

To address this critical issue, an application has been developed to empower users with the ability to monitor CO levels within their garage environment effectively. By leveraging this application, users can remotely track the concentration of CO in real-time. This provides valuable insights into the safety of the environment and enables proactive measures to mitigate the risks associated with CO exposure.

One such precautionary action facilitated by the application is the remote operation of the garage door. Users can remotely open the garage door by a few centimeters, allowing fresh air to enter and facilitate the ventilation process. This helps in effectively dissipating CO and other harmful gases, significantly reducing the potential health hazards that may arise due to prolonged exposure.

By combining advanced monitoring capabilities and remote control functionalities, this innovative solution empowers individuals to safeguard their well-being and that of their loved ones. The integration of such technology exemplifies a proactive approach in addressing the inherent risks associated with CO accumulation, underscoring the importance of user safety and environmental well-being.

## Guest Access

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/guest%20access.png"  width="300" align="center" alt="guest"/>

In order to enhance both convenience and security for our residents and their guests, our smart garage system incorporates a unique feature that allows temporary access to be granted to visitors. When guests arrive, our intuitive mobile application empowers residents to generate a personalized and secure UID (Unique Identifier) along with a password specifically for their guests. This customized access credential enables guests to utilize the smart garage system seamlessly during their stay.

To ensure optimal safety and privacy, we have implemented a comprehensive control mechanism that enables residents to disable or revoke the assigned UID and password once their guest's visit comes to an end. By deactivating the access credentials, only individuals who are currently present within the residence premises will be able to access the garage through the smart system, providing an additional layer of comfort and safeguarding against unauthorized entry.

Our top priority is to deliver a seamless and secure experience, combining advanced technology with user-friendly controls. By offering this innovative feature, we strive to create a welcoming environment for residents and their guests, fostering a sense of trust and peace of mind within our smart home ecosystem.

## Vehicle Maintenance and Reminder System

<img src="https://raw.githubusercontent.com/jashanpreet-singh-99/smart_garage/master/vehicle%20management.png"  width="300" align="center" alt="vm">

The Vehicle Maintenance system encompasses various essential tasks such as engine oil change, brake oil change, air filter change, and tire change. These maintenance activities play a crucial role in ensuring the optimal performance and longevity of a vehicle.

For the engine oil change, the system employs an intelligent approach by providing timely notifications to the user. These notifications are triggered when the vehicle's oil mileage approaches a predetermined checkpoint, typically set at 100 miles before the recommended interval for oil change. By proactively notifying the user, the system promotes regular maintenance and helps to prevent potential engine issues that may arise from neglecting oil changes.

Regarding brake oil change, the system relies on the last service date as a key factor in determining the appropriate time for this maintenance task. By considering the elapsed time since the last brake oil service, the system ensures that the user receives timely reminders to maintain the optimal performance and safety of the braking system.

The air filter change is another important aspect of vehicle maintenance addressed by the system. Based on the last service date, the system tracks the duration since the air filter was last replaced. By monitoring this information, the system provides notifications to the user, ensuring that the air filter is promptly replaced at the recommended intervals. This proactive approach helps to maintain the vehicle's air quality, fuel efficiency, and overall engine performance.

Additionally, the system offers notifications for tire change based on seasonal considerations. When the summer season arrives, the user will receive timely reminders to change the tires. By considering the changing weather conditions and the specific requirements of summer driving, the system helps users maintain optimal traction, handling, and safety on the road.

In summary, the Vehicle Maintenance system offers a comprehensive approach to managing essential maintenance tasks for a vehicle. By leveraging various factors such as oil mileage, service dates, and seasonal considerations, the system ensures that users receive timely reminders for engine oil change, brake oil change, air filter change, and tire change. This proactive and intelligent system helps users maintain their vehicles in top condition, promoting safety, performance, and longevity.
