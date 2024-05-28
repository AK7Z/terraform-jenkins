#!groovy

import jenkins.model.*
import hudson.security.*
import org.jenkinsci.main.modules.cli.auth.ssh.*
//import hudson.util.*;
//import jenkins.install.*;

def instance = Jenkins.getInstance()

// Create a new user database and set it as the security realm
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
instance.setSecurityRealm(hudsonRealm)
hudsonRealm.createAccount("${admin_username}", "${admin_password}") // Set username and password

// Set up a full control once logged in authorization strategy
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

//instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
instance.save()