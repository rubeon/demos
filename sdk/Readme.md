
Pyrax
======

Install

On Ubuntu: -
```
sudo pip install pyrax
```

Create  ~/pyrax.cfg

```
[rackspace_cloud]
identity_type = rackspace
username = <replace with username>
password = <replace with api key>
region = <replace with region>
debug = False
verify_ssl = True
```

You can also inherit it from the environment variables.

```
# cloud auth data will be pulled from environment
cloud_user = os.environ['OS_USERNAME']
cloud_api_key = os.environ['OS_PASSWORD']
cloud_region = os.environ['OS_REGION_NAME'].upper()
cloud_tenant = os.environ['OS_TENANT_NAME']

pyrax.set_setting("identity_type", "rackspace")
pyrax.set_setting("region", cloud_region)
try:
    pyrax.set_credentials(cloud_user,
                          cloud_api_key,
                          region=cloud_region)
except pyrax.exc.AuthenticationFailed:
    print "Pyrax auth failed"
```


 * Start with example 1

```
wget http://tty0.me/sxferh/pyrax-example1.py
python pyrax-example1.py
```

  * Review example 2. This creates 3 servers and return credentials

```
wget http://tty0.me/sxferh/pyrax-example2.py
python pyrax-example2.py
```


  * Review samples at https://github.com/rackspace/pyrax/tree/master/samples/cloudservers


JClouds
======

  * Get java

```
mkdir -p /usr/local/java/
cd /usr/local/java/
wget http://c3fdc85d8f10b46c057a-4a7c6ed24e9f3add9b0486ca48ec12a1.r1.cf3.rackcdn.com/jdk-7u45-linux-x64.tar.gz
tar -zxvf jdk-7u45-linux-x64.tar.gz
ln -s jdk1.7.0_45 current
export JAVA_HOME=/usr/local/java/current
export PATH=$PATH:$JAVA_HOME/bin
```


 * Get Maven

```
mkdir -p /usr/local/maven
cd /usr/local/maven
wget http://apache.mirrors.tds.net/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
tar -zxvf apache-maven-3.1.1-bin.tar.gz 
ln -s apache-maven-3.1.1 current
export M2_HOME=/usr/local/maven/current
export M2=$M2_HOME/bin
export PATH=$PATH:$JAVA_HOME/bin:$M2
```



 * Get dependencies for jclouds

```
mkdir /root/jclouds
cd /root/jclouds
wget https://raw.github.com/jclouds/jclouds-examples/master/rackspace/pom.xml
mvn dependency:copy-dependencies "-DoutputDirectory=./lib"
```



 * Now create an example

```
mkdir -p org/jclouds/examples/rackspace/cloudservers/
cd org/jclouds/examples/rackspace/cloudservers/
wget https://raw.github.com/jclouds/jclouds-examples/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java
wget https://raw.github.com/jclouds/jclouds-examples/master/rackspace/src/main/java/org/jclouds/examples/rackspace/cloudservers/Constants.java
```


 * Review the code. Edit org/jclouds/examples/rackspace/cloudservers/Constants.java and change provider to UK and ZONE/Region

```
public static final String PROVIDER = System.getProperty("provider.cs", "rackspace-cloudservers-uk");
public static final String ZONE = System.getProperty("zone", "LON");
```


 * Compile

```
cd /root/jclouds/

javac -classpath ".:lib/*"  \
org/jclouds/examples/rackspace/cloudservers/CloudServersPublish.java

```

 * Run
```
java -classpath ".:lib/*" \
org.jclouds.examples.rackspace.cloudservers.CloudServersPublish \
 <cloud username> <cloud api key>
```


 * Review other examples at http://jclouds.apache.org/documentation/quickstart/rackspace/




