#!groovy

// imports
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.*
import hudson.util.Secret
import java.nio.file.Files
import jenkins.model.Jenkins
import net.sf.json.JSONObject
import org.jenkinsci.plugins.plaincredentials.impl.*

// parameters
def slaveKeyParameters = [
  description:  'Slave SSH Access Key',
  id:           'slave-ssh-access',
  secret:       '',
  userName:     'ubuntu',
  key:          new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource('''${private_key_pem_source}''')
]

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()

// get credentials domain
def domain = Domain.global()

// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// define private key
def privateKey = new BasicSSHUserPrivateKey(
  CredentialsScope.GLOBAL,
  slaveKeyParameters.id,
  slaveKeyParameters.userName,
  slaveKeyParameters.key,
  slaveKeyParameters.secret,
  slaveKeyParameters.description
)

// add credential to store
store.addCredentials(domain, privateKey)

// save to disk
jenkins.save()
