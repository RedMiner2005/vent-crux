# Vent - By Pratyush
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

Voice Every Nagging Thought - A project for CRUx R3, 2023-24 Sem 2.
The task is to create a semi-social mobile app with Flutter that lets users share their thoughts
about other users anonymously.

The web service repo can be found [here](https://github.com/RedMiner2005/vent-crux-backend)

## Features
1. Authentication works only with phone number, with SMS verification (Firebase Auth)
2. The only data stored outside the device are SHA256 hashes of the phone numbers (serving as the UIDs in Cloud Firestore), notification token, and received vents
3. Users can either type or record their voice (which will be transcribed) to vent their feelings
4. The vent is anonymously sent to the Vent web service which sends a request to a `llama3-8b` model hosted on [Groq](https://groq.com) which then removes all references to the name of the receiver, extracts the name of the receiver if any and also verifies if the user is actually talking about some other person and not themselves or some random topic. The payload to the LLM includes an instruction prompt as well as several examples.
5. The contact list is then cross-referenced with the registered users using a secure technique that prevents any of the contacts from being sent outside the device (further details will be mentioned in the corresponding brownie point section)
6. If the name extracted matches exactly with one contact, it automatically sends the vent to that contact. Otherwise, the user can choose from a list of partial matches (or all registered users in contacts, if no matches were found or the recipient is not mentioned, all users are shown)
7. The Inbox page is on the right of the Home page (swipe, or press the button), where all the vents you receive are shown (along with unread indicators for new vents). Vents are anonymously sent, with no information about the sender stored (the vent is directly added to the recipients data)
8. The app is designed to be minimalistic, yet look beautiful, with every aspect of it beautifully animated (my personal favourite, the bottom bar expanding to the contact dialog)

> [!NOTE]
> The requests to the LLM include a lot of example prompts, but the context window of the model used is a limitation for the accuracy of the model. Enough data for fine tuning a model, say GPT-3.5, is available on the web service repo, of which only a fraction is used in these requests due to this limitation. Transitioning to other models is thus simplified (I could have used it from the start, but I didn't want to spend on this project☺️)

## Brownie Points
- [x] The app does infer the target user directly from the user input and matches it with the contact list
- [x] The entire contact list never leaves the user's phone. The app goes through the contact list, hashes the phone numbers and check the existence of users with those UIDs. The phone numbers of users are not stored anywhere, making the entire system more secure and anonymous.
- [ ] Implement an indicator that reacts to the amplitude of audio while recording. I was unable to do this due to reasons I still don't understand (I somehow ended up breaking the entire gradle and Kotlin configs😂)

## Screenshots
<p>
  <img src="https://github.com/RedMiner2005/vent-crux/blob/master/screenshots/Login.gif" width="25%"/>
  <img src="https://github.com/RedMiner2005/vent-crux/blob/master/screenshots/Voice.gif" width="25%"/>
  <img src="https://github.com/RedMiner2005/vent-crux/blob/master/screenshots/ContactsDialog.gif" width="25%"/>
</p>

## How to run?
* Install the release APK on Android. It connects to [vent-crux-backend.onrender.com](vent-crux-backend.onrender.com). Note that Render (the platform on which it is hosted) spins down the web service, so after inactivity, it will take some time to start up (you'll notice that through request timeouts)
* Alternatively, clone the repository onto your device, open the project on Android Studio/VS Code with Flutter (with the right version of JDK) installed. Configure the project with a Firebase project with Phone Auth, Firestore, Analytics/Crashlytics, Firebase Messaging enabled. Add your release certificate info in key.properties (android folder) and add the SHA1 and SHA256 keys to your project.

## Remarks
A huge thanks to CRUx BPHC for this opportunity. I really like the idea of the project, it's something simple but nice.
It also gave me a chance to try and explore as much UI design as possible in Flutter.
Along with that, I discovered how powerful Flutter Bloc is, as a state management system, and even though I used it pretty inefficiently, it still simplified a lot of stuff.
