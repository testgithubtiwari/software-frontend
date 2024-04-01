# Software-Frontend

Frontend is made in Flutter which is a cross platforms for both ios and android with the same codebase and also I have integrated for web in this project and the web is deployed on the AWS amplify server while there is Continous Integration and Continous deployemnet software development strategy implemented so that developer focus more time to write code not to waste time on debugging the issue.

## Follow these steps to setup and run the project

### Step1: Check the flutter is installed on your pc or not.

Open terminal and type flutter --verssion

```bash
flutter --version
```

If you see flutter command not found then you have install the flutter and also set the paths in the enviroment variables so that terminal understood the command.

Now check for any requirements, type flutter --doctor in the terminal

```bash
flutter doctor
```

Here if you see Doctor found issues in X category then you have to work upon that category and see how to reslove that because without resolve that you can't able to run any flutter project.

### I hope till now you have setup the flutter correctly.

#### Now here are the few commands to run this project.

Open the terminal and go to the root directory of the project where you can see the pubspec.yaml file and now run

```bash
flutter pub get
```

It will install all the dependencies required for this project.

```bash
flutter run
```

It will show the option ti run the flutter project on the available devices it may be chrome, emulator, etc.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
