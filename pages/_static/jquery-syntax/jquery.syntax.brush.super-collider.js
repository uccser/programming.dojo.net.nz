// This file is part of the "jQuery.Syntax" project, and is distributed under the MIT License.
// Copyright (c) 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>


Syntax.register('super-collider',function(brush){var keywords=["arg","classvar","var"];var operators=["`","+","@",":","*","/","-","&","|","~","!","%","<","=",">"];var values=["self","super","true","false","nil","inf"];brush.push(keywords,{klass:'keyword'});brush.push(operators,{klass:'operator'});brush.push(values,{klass:'constant'});brush.push(Syntax.lib.camelCaseType);brush.push({pattern:/\$./g,klass:"constant"});brush.push({pattern:/\\[a-z_][a-z0-9_]*/gi,klass:"symbol"});brush.push(Syntax.lib.cStyleComment);brush.push(Syntax.lib.cppStyleComment);brush.push(Syntax.lib.webLink);brush.push(Syntax.lib.singleQuotedString);brush.push(Syntax.lib.doubleQuotedString);brush.push(Syntax.lib.stringEscape);brush.push(Syntax.lib.decimalNumber);brush.push(Syntax.lib.hexNumber);brush.push({pattern:/(?:\.)([a-z_][a-z0-9_]*)/gi,matches:Syntax.extractMatches({klass:'function'})});brush.push(Syntax.lib.cStyleFunction);});