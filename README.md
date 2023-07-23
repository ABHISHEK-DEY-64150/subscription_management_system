# Subscription Management System

## Introduction
 
This web application manages customers subscription and billing of the packages for a particular provider.
 



## Provider Features:
<u>
<ul>
<li> After a successful provider login, provider can see the summery of the system on Dashboard that includes: </li>
<ul>
<li>Number of customers</li>
<li> Number of subscriptions</li>
  <li>Total monthly earnings</li>
  <li>Graph representing earnings of the past 12 months</li>
  <li>Pie chart of different types of packages</li>
</ul>
<li> Provider can register a customer providing all his details and subscribe to a particular package </li>
<li> Provider can lookup all his customers and search for a particular customer and see the profile that includes:</li>
<ul>
<li>Customer details can  be found</li>
<li>Customers' subscibed packages</li>
<li> Due bills can be found</li>
  <li>Provider can confirm payment</li>
  <li>subscribe the customer to a new package</li>
</ul>
<li> Lookup all his packages of different  servicetype</li>
  <li>Create new packages </li>
    <li>Bill functionalities</li>
<ul>
<li>Generate monthly bill</li>
<li>Download receipt for offline payment</li>
<li> Confirm payment</li>
  <li>Query monthly bill</li>
  <li>Lookup previous year/monthly bills</li>
</ul>
  <u>
    <li>Provider can view reviews from his customers and reply to the reviews</li>
  </u>
</ul> 
   
## Customer Features:
<ul>
<li> After a successful Customer login, customer will be able to see his profile </li>
<li> Customer can view all his subscriptions </li>
<li> Lookup all unpaid bills and pay for the particular package </li>
<li> View previous transaction history,download receipt </li>
<li> Give reviews to the provider and see providers reply </li>  
</ul>


## Used Technologies:
<ul>
Ruby on rails with Sqlite3 database
  <li>Ruby version : 3.2.2</li>
  <li>Rails version : 7.0.5</li>
</ul>

## Clone this Project:
```
git@github.com:ABHISHEK-DEY-64150/subscription_management_system.git
```

## To run the project
Install Depedencies :
```
bundle install
```
At first admin setup to database through rails console:
```
rails console
```
```
P = Provider.create(email:"admin@gmail.com",password:"pass")
```

run:
```
rails server
```


# Some Screenshots:

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-34-52.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-35-06.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-39-46.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-42-12.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-42-26.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-48-05.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-48-22.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-48-43.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-49-03.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-50-16.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-50-32.png"  height = "400"/> </p>

<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-51-21.png"  height = "400"/> </p>


<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-51-57.png"  height = "400"/> </p>


<p  align="center"  >
<img  src="Project Pictures/Screenshot from 2021-12-13 22-52-47.png"  height = "400"/> </p>





## Developed by,
- <b>[ Abhishek Dey (2017331021)](https://github.com/ABHISHEK-DEY-64150)</b>
- <b>[Sani Talukder (2017331023)](https://github.com/sani-1023)</b>

