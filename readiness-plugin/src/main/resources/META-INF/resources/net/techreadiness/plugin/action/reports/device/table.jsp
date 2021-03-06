<!DOCTYPE html>
<%@taglib prefix="ui" uri="http://techreadiness.net/components"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<head>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/reporting.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/reporting.js"></script>
	<script type='text/javascript' src='https://www.google.com/jsapi'></script>
	<script type="text/javascript"><c:out value="${geoChart.chart}" escapeXml="false" /></script>

</head>
<body>
<s:a id="selectOrg" cssStyle="display: none;" aria-hidden="true">
		<s:param name="viewBy">
			<c:out value="${viewBy}" />
		</s:param>
		<s:param name="consortium">
			<c:out value="${consortium}" />
		</s:param>
	</s:a>
<jsp:include page="../breadcrumbs.jsp" />

<div class="report-layout-wrapper">
<table class="report-layout">
	<tr>
		<td class="left">
			<c:if test="${ dualConsortium }">
				<div>Consortium</div>
				<div class="report-toggle">
					<s:form action="deviceAssessment" id="consortiumForm" method="get">
						<c:choose>
							<c:when test="${consortium eq 'SBAC'}">
								<label class="radio inline">
									<input type="radio" name="consortium" value="SBAC" checked="checked">
									SBAC
								</label>
								<label class="radio inline">
									<input type="radio" name="consortium" value="PARCC">
									PARCC
								</label>
							</c:when>
							<c:otherwise>
								<label class="radio inline">
									<input type="radio" name="consortium" value="SBAC">
									SBAC
								</label>
								<label class="radio inline">
									<input type="radio" name="consortium" value="PARCC" checked="checked">
									PARCC
								</label>
							</c:otherwise>
						</c:choose>
						<s:hidden name="viewBy"/>
						<s:hidden name="requirements"/>
						<s:hidden name="snapshotName"/>
						<s:hidden name="snapshotScopeId"/>
					</s:form>
				</div>	
			</c:if>
			<div id='mapDiv' style="height: ${ geoChart.height }px; width: ${ geoChart.width }px; margin: auto"></div>
		</td>
		<td class="center">
			<div class="report-header">Device Indicators</div>
			<div class="reports-updated-note">Reports are updated hourly</div> 
			<c:if test="${ orgSummary['createDate'] != null }">
				<div class="report-born-on">Data as of ${ orgSummary['createDate'] } </div>
					<c:if test="${ !empty snapshotName }">
						&nbsp;-&nbsp;${ snapshotName == 'default' ? 'Current Window' : snapshotName }
					</c:if>
				</c:if>
			<c:choose>
				<c:when test="${ orgSummary['devicePassingPercent'] == null or orgSummary['devicePassingPercent'] == 'TBD' }">
					<div class="report-org-text">
						<div class="tbd">TBD</div>
						<div class="report-label">${ consortium } - </div>
						<div class="report-label2">It <span class="text-underline">cannot</span> be determined what % of Devices Meet the ${ requirements } Requirements</div><div style="clear: both;"></div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="report-org-text">
						<div class="color <s:property value="getPercentColor(orgSummary['devicePassingPercent'])"/>"></div>
						<div class="report-label">${ consortium } - </div>
						<div class="report-label2">${ orgSummary['devicePassingPercent'] } of Devices Meet the ${ requirements } Requirements <img src="${pageContext.request.contextPath}/static/images/moreinfo-reverse.png" title="Number of Devices that Meet Requirements / Total number of devices"/></div><div style="clear: both;"></div>
					</div>
				</c:otherwise>
			</c:choose>
			
			<div class="disclaimer-text1"> <s:text name="ready.report.disclaimer.device.text1"/></div>
			<div class="disclaimer-text1"> <s:text name="ready.report.consortia.text">
			  <s:param value="consortium" /></s:text>
			  <c:choose>
				<c:when test="${consortium == 'SBAC'}"> 
	 					<a href='http://www.techreadiness.org/SBACrequirements' target="_blank"> <span class="report-link"> here</span>.</a>
	  			 </c:when>
	 			<c:when test="${consortium == 'PARCC'}"> 
	 					<a href='http://www.techreadiness.org/PARCCrequirements' target="_blank"> <span class="report-link"> here</span>.</a>
	  			</c:when>
	  			<c:otherwise>
	  			</c:otherwise>
			  </c:choose>
			</div>
			
			<div class="report-requirements">
				<div class="report-label">Requirements</div>
				<div class="data">
					<s:form action="deviceAssessment">
						<s:select name="requirements" list="#{ 'Minimum':'Minimum', 'Recommended':'Recommended' }" onchange="this.form.submit()"/>
						<s:hidden name="viewBy"/>
						<s:hidden name="consortium"/>
						<s:hidden name="snapshotName"/>
						<s:hidden name="snapshotScopeId"/>
					</s:form>
				</div>				
			</div>
			<div style="clear: both;"></div>
			<div class="report-subheading">
				<ui:flyout text="Minimum / Recommended Requirements" title="Minimum / Recommended Requirements" namespace="/reports/device" action="minRequirements" reset="true" consortium="${ consortium }" snapshotName="${ snapshotName }" snapshotScopeId="${ snapshotScopeId }" />	
			</div>
		</td>
		<td class="right">
		   <c:if test="${ orgSummary['createDate'] != null }">
			  <div class="report-buttons">
				<button type="submit" class="btn btn-xs btn-default print-button" onclick="$('#downloadPdf').submit();"><img src="${pageContext.request.contextPath}/static/images/icons/printer.png" class="report-button-image">Print to .pdf</button>
			  </div>
		   </c:if>	  
			<div style="clear: both;"></div>
			<div class="report-legend">
				<div class="header"><c:out value="${legendTitle}" /></div>
				
				<div class="legend-row">
					<div class="color" style="background-color:#e5e5e5"></div>
					<div class="report-label">Not a Member</div>
				</div>
				
				<div class="legend-row">
					<div class="report-label"><ui:flyout text="TBD" title="Why are some reports showing TBD as a value?" namespace="/reports/device" action="TBD" reset="true" /></div>
				</div>
				
				<div class="legend-row">
					<div class="color report-level1"></div>
					<div class="report-label">0%-25%</div>
				</div>
				
				<div class="legend-row">
					<div class="color report-level2"></div>
					<div class="report-label">26%-50%</div>
				</div>
				
				<div class="legend-row">
					<div class="color report-level3"></div>
					<div class="report-label">51%-75%</div>
				</div>
				
				<div class="legend-row">
					<div class="color report-level4"></div>
					<div class="report-label">76%-100%</div>
				</div>
			</div>
		</td>
	</tr>
</table>
</div>

<div class="datagrid-toggle">
<s:form action="deviceAssessment" id="viewByForm" method="get">
	<c:choose>
		<c:when test="${viewBy eq 'map'}">
			<label class="radio inline">
				<input type="radio" name="viewBy" value="map" checked="checked">
				Map
			</label>
			<label class="radio inline">
				<input type="radio" name="viewBy" value="table">
				Table
			</label>
		</c:when>
		<c:otherwise>
			<label class="radio inline">
				<input type="radio" name="viewBy" value="map">
				Map
			</label>
			<label class="radio inline">
				<input type="radio" name="viewBy" value="table" checked="checked">
				Table
			</label>
		</c:otherwise>
	</c:choose>
	<s:hidden name="consortium"/>
	<s:hidden name="requirements"/>
	<s:hidden name="snapshotName"/>
	<s:hidden name="snapshotScopeId"/>
</s:form>
<s:form action="deviceAssessment" id="selectOrg">
	<s:hidden name="viewBy"/>
	<s:hidden name="consortium"/>
	<s:hidden name="orgCode" id="orgCode"/>
	<s:hidden name="requirements"/>
	<s:hidden name="snapshotName"/>
	<s:hidden name="snapshotScopeId"/>
</s:form>
<s:form action="download" id="downloadCsv">
	<s:hidden name="viewBy"/>
	<s:hidden name="consortium"/>
	<s:hidden name="fileType" value="csv"/>
	<s:hidden name="requirements"/>
	<s:hidden name="snapshotName"/>
	<s:hidden name="snapshotScopeId"/>
</s:form>
<s:form action="download" id="downloadPdf">
	<s:hidden name="viewBy"/>
	<s:hidden name="consortium"/>
	<s:hidden name="fileType" value="pdf"/>
	<s:hidden name="requirements"/>
	<s:hidden name="snapshotName"/>
	<s:hidden name="snapshotScopeId"/>
</s:form>
</div>
<div style="clear: both;"></div>
<s:form>
	<ui:datagrid itemProvider="${reportItemProvider}" value="reportGrid" var="device" selectable="false" rowValue="device.orgCode" >
		<ui:dataGridHeader>
		  <c:if test="${ orgSummary['createDate'] != null }">
			 <button type="button" class="btn btn-xs btn-default export-button" onclick="$('#downloadCsv').submit();">
				<img src="${pageContext.request.contextPath}/static/images/icons/export.png" class="report-button-image">Export to .csv
			 </button>
		  </c:if>	 
		</ui:dataGridHeader>
		<ui:dataGridColumn code="orgName" name="Organization">
			<s:a includeParams="get" action="deviceAssessment" namespace="/reports/device">
				<s:property value="device.orgName"/>
				<s:param name="orgCode" value="device.orgCode" />
			</s:a>
		</ui:dataGridColumn>
		<ui:dataGridColumn code="orgCode" name="Org Code">
			<s:property value="device.orgCode"/>
		</ui:dataGridColumn>
		<ui:dataGridColumn code="totalDevices" name="Total Devices">
			<s:property value="device.deviceCount"/>
		</ui:dataGridColumn>
		<ui:dataGridColumn code="numberDevices" name="# Devices Meeting<br>All ${ requirements } Requirements">
			<s:property value="device.devicePassingCount"/>
		</ui:dataGridColumn>
		<ui:dataGridColumn code="percentDevices" name="% Devices Meeting<br>All ${ requirements } Requirements <img src='${pageContext.request.contextPath}/static/images/moreinfo-reverse.png' title='# of Devices Meeting Requirements / Total number of devices'>">
			<div class="report-datagrid-color-icon">
				<div class="color <s:property value="getPercentColor(device.devicePassingPercent)"/>"></div>
				<div class="report-label"><s:property value="device.devicePassingPercent"/></div>
				<c:if test="${ device.deviceTbdCount > 0 }">
					<span class="tbd">TBD</span>
				</c:if>
			</div>
		</ui:dataGridColumn>
	</ui:datagrid>
</s:form>

</body>