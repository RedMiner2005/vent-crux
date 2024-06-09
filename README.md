# Vent - By Pratyush
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

Voice Every Nagging Thought - A project for CRUx R3, 2023-24 Sem 2.
The task is to create a semi-social mobile app with Flutter that lets users share their thoughts
about other users anonymously.

All large files, such as the fine-tuned model, will be in [this folder](https://drive.google.com/drive/folders/1RM144zNfT8wIwAU7H0xQPsNJ7UWmH3V1?usp=sharing).

The server repo can be found [here](https://github.com/RedMiner2005/vent-crux-backend)

## Roadmap
- [x] Set up Flutter Bloc
- [x] Create a login system based on phone number
- [ ] Onboarding screen
- [x] Create the home page (text input + voice input) (Rough)
- [x] Set up a server to manage requests to a llama-3-8b model with a predetermined set of system instructions and example prompts, using the Groq platform (vent-crux-backend)
- [ ] ~~Deploy vosk on device~~
- [x] Obtain contact list and filter based on registered users
- [x] Contact picker screen (Rough)
- [x] Send messages to the user, 'Received' screen (Rough)
- [x] Receive notifications

## Brownie Points
- [x] Automatic contact inference : Works well, except sometimes 'he', 'she' are recognized as contacts
- [x] Entire contact list does not leave the phone: However, the presence of documents with SHA 256 hash of the number as ID is checked on Firestore
- [ ] Indicator that reacts to loudness when a user's voice is being recorded