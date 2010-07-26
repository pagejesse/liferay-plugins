<%
/**
 * Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ include file="/init.jsp" %>

<%
Map<String, UserPref> userPrefs = (Map<String, UserPref>)renderRequest.getAttribute(WebKeys.USER_PREFS);

String namespace = ShindigUtil.getPortletResourceNamespace(renderRequest, themeDisplay);

JSONObject jsonObject = ExpandoValueServiceUtil.getJSONData(themeDisplay.getCompanyId(), User.class.getName(), ShindigUtil.getTableOpenSocial(), ShindigUtil.getColumnUserPrefs(namespace), themeDisplay.getUserId());
%>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm">
	<aui:fieldset>

		<%
		for (UserPref userPref : userPrefs.values()) {
			UserPref.DataType dataType = userPref.getDataType();
			String displayName = userPref.getDisplayName();
			String name = userPref.getName();
			String value = userPref.getDefaultValue();

			if (jsonObject != null) {
				value = GetterUtil.getString(jsonObject.getString(userPref.getName()), value);
			}


		%>

			<c:choose>
				<c:when test="<%= dataType == UserPref.DataType.BOOL %>">
					<aui:select label="<%= displayName %>" name="<%= name %>">
						<aui:option label='<%= LanguageUtil.get(pageContext, "yes") %>' selected="<%= GetterUtil.getBoolean(value) %>" />
						<aui:option label='<%= LanguageUtil.get(pageContext, "no") %>' selected="<%= !GetterUtil.getBoolean(value) %>" />
					</aui:select>
				</c:when>
				<c:when test="<%= dataType == UserPref.DataType.ENUM %>">
					<aui:select label="<%= displayName %>" name="<%= name %>">
						<%
						for (UserPref.EnumValuePair enumValuePair: userPref.getOrderedEnumValues()) {
							String enumValue = enumValuePair.getValue();
						%>

							<aui:option label="<%= enumValuePair.getDisplayValue() %>" selected="<%= value.equals(enumValue) %>" value="<%= enumValue %>" />

						<%
						}
						%>

					</aui:select>
				</c:when>
				<c:when test="<%= dataType == UserPref.DataType.HIDDEN %>">
				</c:when>
				<c:otherwise>
					<aui:input cssClass="lfr-input-text-container" label="<%= userPref.getDisplayName() %>" name="<%= userPref.getName() %>" type="text" value="<%= value %>" />
				</c:otherwise>
			</c:choose>

		<%
		}
		%>

	</aui:fieldset>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>