<cfif structKeyExists(url,'logout')>
	<cfset structDelete(session , 'loggedIn') />
	<cfset variables.redirectURL = "https://" & "#CGI.SERVER_NAME#" & "#CGI.SCRIPT_NAME#" & "?subCat=#url.subCat#" />
	<cflocation url = "#variables.redirectURL#"  addToken = "no" />
</cfif>


<!--- if url parameter is not given then page will be redirected to index page --->
<cfif NOT structKeyExists(url,'subCat')>
	<cflocation url="index.cfm" addToken = "no" />
</cfif>

<!--- fetching the all the mobile products --->
<cfset resultProductDetail = application.productService.getProductDetailBySubCategoryID(url.subCat) />

<!--- fetching the name of categories and name of subcategories --->
<cfset resultCategories = application.productService.getCategoryByGroup() />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Home | E-Shopper</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="css/prettyPhoto.css" rel="stylesheet">
    <link href="css/price-range.css" rel="stylesheet">
    <link href="css/animate.css" rel="stylesheet">
	<link href="css/main.css" rel="stylesheet">
	<link href="css/responsive.css" rel="stylesheet">
    <link rel="shortcut icon" href="images/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="images/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="images/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="images/ico/apple-touch-icon-57-precomposed.png">
</head><!--/head-->

<body>
	<header id="header"><!--header-->
		<div class="header_top"><!--header_top-->
			<div class="container">
				<div class="row">
					<div class="col-sm-6 ">
						<div class="contactinfo">
							<ul class="nav nav-pills">
								<li><a href=""><i class="fa fa-phone"></i> +2 95 01 88 821</a></li>
								<li><a href=""><i class="fa fa-envelope"></i> info@domain.com</a></li>
							</ul>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="social-icons pull-right">
							<ul class="nav navbar-nav">
								<li><a href=""><i class="fa fa-facebook"></i></a></li>
								<li><a href=""><i class="fa fa-twitter"></i></a></li>
								<li><a href=""><i class="fa fa-linkedin"></i></a></li>
								<li><a href=""><i class="fa fa-dribbble"></i></a></li>
								<li><a href=""><i class="fa fa-google-plus"></i></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div><!--/header_top-->

		<div class="header-middle"><!--header-middle-->
			<div class="container">
				<div class="row">
					<div class="col-sm-4">
						<div class="logo pull-left">
							<a href="index.cfm"><img src="images/home/logo.png" alt="" /></a>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="shop-menu pull-right">
							<ul class="nav navbar-nav">
								<li><a href="index.cfm">Home</a></li>
								<li><a href="cart.cfm"><i class="fa fa-shopping-cart"></i> Cart</a></li>
								<!--- checking the session for logged in user ---->
								<cfif structKeyExists(session,'loggedIn') >
									<li><a href = "orders.cfm">Orders</a></li>
									<li><a>Hello <cfoutput>#session.loggedIn['customerName']# !</cfoutput></a></li>
									<cfset variables.currentURL = "https://" & "#CGI.SERVER_NAME#" & "#CGI.SCRIPT_NAME#" & "?subCat=#url.subCat#&logout" />
									<li><a href = "<cfoutput>#variables.currentURL#</cfoutput>">Logout</a></li>
								<cfelse>
									<li><a href="login.cfm"><i class="fa fa-lock"></i> Login</a></li>
								</cfif>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div><!--/header-middle-->
	</header>
	<section>
		<div class="container head">
			<div class="row">
				<div class="col-sm-3">
					<div class="left-sidebar">
						<h2>Category</h2>
						<div class="panel-group category-products" id="accordian"><!--category-productsr-->
						<!--- accessing the categories with their sub categories to show category menu --->
							<cfoutput query = "resultCategories" group = "CATEGORY" >
								<div class="panel panel-default">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a data-toggle="collapse" data-parent="##accordian" href="###resultCategories.CATEGORYID#">
												<span class="badge pull-right"><i class="fa fa-plus"></i></span>
												#resultCategories.CATEGORY#
											</a>
										</h4>
									</div>
									<div id="#resultCategories.CATEGORYID#" class="panel-collapse collapse">
										<div class="panel-body">
											<ul>
												<cfoutput>
												<li><a href="allproducts.cfm?subCat=#resultCategories.SUBCATEGORYID#">#resultCategories.SUBCATEGORY#</a></li>
												</cfoutput>
											</ul>
										</div>
									</div>
								</div>
							</cfoutput>
						</div><!--/category-productsr-->
					</div>
				</div>

				<div class="col-sm-9 padding-right">
					<div class="features_items"><!--features_items-->
					<!--- showing the details of the products --->
						<cfoutput query = "resultProductDetail" >

								<div class="col-sm-4" >
									<a href="product-detail.cfm?productID=#resultProductDetail.PRODUCTWITHSELLERID#">
										<div class="product-image-wrapper">
											<div class="single-products">
												<div class="productinfo text-center">
													<img src="#resultProductDetail.IMAGEURL#" alt="" />
													<h2>#resultProductDetail.PRICE# Rs.</h2>
													<p>#resultProductDetail.PRODUCTNAME#</p>
												</div>
											</div>
										</div>
									</a>
								</div>
						</cfoutput>
					</div><!--features_items-->
				</div>
			</div>
		</div>
	</section>

	<footer id="footer"><!--Footer-->
		<div class="footer-bottom">
			<div class="container">
				<div class="row">
					<p class="pull-left">Copyright � 2017 E-Shopper. All rights reserved.</p>
				</div>
			</div>
		</div>

	</footer><!--/Footer-->



    <script src="js/jquery.js"></script>
	<script src="js/price-range.js"></script>
    <script src="js/jquery.scrollUp.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.prettyPhoto.js"></script>
    <script src="js/main.js"></script>
</body>
</html>