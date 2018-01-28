# Setting Up the Project
1. install pods (pod install)
2. Debug mode in Constants to enable/ disable login buttons for a test normal user and admin user

# FeatureList
## Login:
1. Login user or register user if no account is available yet (Daniel)

## Categories: 
1. Click to specific category (Steffi)
2. Create new category (Daniel)

## Topics:
1. Swipe through topics (Gregor)
2. Create new topic (Daniel)

## Opinion selection:
1. Select opinion (Steffi) 
2. Match user with another user with opposite Opinion (Steffi)

## personalChats:
1. 1 and 1 chat (see only your active chats) (Daniel)
2. Chat restrictions
    + Users are only allowed to write three messages in one row (Steffi)
    + Users are only allowed to enter less than 250 charakters in one chatmessage (Steffi)
    + Users are not allowed to copy-paste more than one charakter into chatmessage (Steffi)
3. settings
    + Select next user (Steffi)
    + Exit chat (Daniel)
    + Report user (Steffi)
    + Behave regulates (Benedikt)

## All Chats:
1. See all active chats to watch them (Daniel)
2. Show statistics to chat (Daniel)
3. Vote for pro or contra (Steffi)
4. Chat deletes itself, if last message is older than 3 days old (Steffi)

## Optionsscreen:
1. Show optionsscreen (Daniel)
2. Change username (Benedikt)
3. Change email-adress (Benedikt)
4. Delete account (Benedikt)
5. Logout (Daniel)

## extraFeatures:
1. User and admin- role distinction (Steffi)
2. Anonymous user (only for watching all chats) (Daniel)
3. Proposing a topic as a user (Gregor)
4. Reviewing proposed topics and either delete or create new topic as admin (Gregor)
5. Designing and implementing custom icons(app icon, tab icons) (Gregor)

# User Administration in detail, 3 types of Users: 
1. Admin Users
    + can create new categories, and discussion topics 
    + and can do everything that a normal user can do
    + (only admin of firebase is possible to give you adminrights)
    + can view/delete/approve proposed topics
2. Normal users 
    + can make opinions on topics
    + get matched with other users based on their opinion and chat with them
    + can see all chats, and vote for pro and contra
    + edit their password, email, logout, delete their account
3. Anonymous users
    + cant edit their password, email, because they have none
    + cant chat with other users, they can only watch all chats
    + cant swipe through topcis

