<!---/**
 * order-receipt
 *
 * @author mindfire
 * @date 8/9/17
 **/ --->
<cfcomponent>
	<!--- fetching the address of customer --->
	<cffunction name = "getAddress" returntype = "query" access = "public" hint = "accessing the address of customer"  >
		<cfargument name = "customerID" required = "true" type = "numeric" hint = "customer's id" />
		<cftry>
			<cfquery name = "getAddress">
				SELECT ADDRESSTYPEID , CUSTOMERADDRESS , CUSTOMERSTATE , CUSTOMERCITY , CUSTOMERZIPCODE
				FROM CUSTOMERADDRESS
				WHERE CUSTOMERID = <cfqueryparam value = "#arguments.customerID#" cfsqltype="cf_sql_numeric" />
			</cfquery>
			<!---- redirecting the error page if database is not connected ---->
			<cfcatch type="any" >
				<cflocation url = "error.cfm" addToken = "no" />
			</cfcatch>
		</cftry>
		<cfreturn getAddress />

	</cffunction>

	<!--- fetching all the details of product that a customer has ordered --->
	<cffunction name = "getOrderDetail" returnType = "query" access = "public" hint = "accessing the order details" >
		<cfargument name = "customerID" required = "true" type = "numeric" hint = "customer's id" />

		<cftry>
			<cfquery name  = "getOrderDetail">
				SELECT P.PRODUCTNAME , PWS.IMAGEURL, PWS.PRICE , PWS.SHIPPINGPRICE  , O.ORDERITEMS , S.SELLERNAME , ( O.ORDERITEMS * (  PWS.PRICE + PWS.SHIPPINGPRICE )) AS ORDERTOTALCOST
				FROM PRODUCTSWITHSELLERS AS PWS
				INNER JOIN CUSTOMERORDERS AS O
				ON PWS.PRODUCTWITHSELLERID = O.PRODUCTWITHSELLERID
				AND O.CUSTOMERTRANSACTIONID = <cfqueryparam value = "#arguments.customerID#" cfsqltype = "cf_sql_numeric" />
				INNER JOIN SELLER AS S
				ON S.SELLERID = PWS.SELLERID
				INNER JOIN PRODUCT AS P
				ON P.PRODUCTID = PWS.PRODUCTID
			</cfquery>
			<!--- redirecting to the error page if database is not connected --->
			<cfcatch type="any" >
				<cflocation url = "error.cfm" addToken = "no" />
			</cfcatch>
		</cftry>
		<cfreturn getOrderDetail />
	</cffunction>


	<!--- fetching the transaction number to be given to the customer after successfull transaction --->
	<cffunction name = "getTransactionNumber" returntype = "string" access = "public" hint = "accessing the transaction number">
		<cfargument name = "transactionId" required = "true" type = "numeric" hint = "transaction payment id" />
		<cftry>
			<cfquery name = "getTransaction">
				SELECT TRANSACTIONNUMBER
				FROM CUSTOMERTRANSACTION
				WHERE CUSTOMERTRANSACTIONID = <cfqueryparam value = "#arguments.transactionId#" cfsqltype = "cf_sql_numeric" />
			</cfquery>
			<!--- redirecting to the error page if databse is not connected --->
			<cfcatch  type="any" >
				<cflocation url = "error.cfm" addToken = "no" />
			</cfcatch>
		</cftry>
		<cfreturn getTransaction.TRANSACTIONNUMBER />
	</cffunction>

	<!--- accessing order history of customer --->
	<cffunction name = "getOrderHistory" returntype = "query" access = "public" hint = "accessing order history of customer" >
		<cfargument name  = "customerID" required = "true" type = "numeric" hint = "i'd of customer login" />

		<cftry>
			<cfquery name = "local.getOrderHistory" >
				SELECT T.TRANSACTIONNUMBER , T.DATE , O.ORDERITEMS , PWS.IMAGEURL , PWS.SHIPPINGPRICE , P.PRODUCTNAME , S.SELLERNAME , (O.ORDERITEMS * ( PWS.PRICE + PWS.SHIPPINGPRICE )) AS TOTALPRICE
				FROM CUSTOMERtRANSACTION AS T
				INNER JOIN CUSTOMERORDERS AS O
				ON O.CUSTOMERTRANSACTIONID = T.CUSTOMERTRANSACTIONID
				AND O.CUSTOMERID = <cfqueryparam value = "#arguments.customerID#" cfsqltype = "cf_sql_numeric" />
				INNER JOIN PRODUCTSWITHSELLERS AS PWS
				ON PWS.PRODUCTWITHSELLERID = O.PRODUCTWITHSELLERID
				INNER JOIN PRODUCT AS P
				ON P.PRODUCTID = PWS.PRODUCTID
				INNER JOIN SELLER AS S
				ON S.SELLERID = PWS.SELLERID
				ORDER BY T.DATE DESC
			</cfquery>
			<!--- redirecting to the error page if databse is not connected --->
			<cfcatch  type="any" >
				<cflocation url = "error.cfm" addToken = "no" />
			</cfcatch>
		</cftry>
		<cfreturn local.getOrderHistory />
	</cffunction>

</cfcomponent>