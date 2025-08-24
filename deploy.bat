@echo off
echo Building Flutter Web App...
flutter build web --release

echo Deploying to Firebase...
firebase deploy --only hosting

echo Deployment complete!
pause
