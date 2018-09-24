# css权威指南

## 第1章 css和文档

* 层叠(cascade):css冲突规则
* css优点：丰富的样式，易于使用，多页面使用，层叠，缩减文件大小，为将来做准备
* 元素(element)是文档结构的基础
  * 替换元素(replaced element),非替换元素(nonrepalced element)
  * 块级元素(block-level element),行内元素(inline-level element)
* 样式表分类：
  * 外部样式表(external style sheet)
    * `<link rel="stylesheet" type="text/css" href="sheet1.css" media="all" />`
      > 多个link，都有相同title，后面的权重大；都有title，title不同，前面的为默认；一个有title，一个无title，后面的权重大（自己实验的结论,不同title理解为不同的样式分组；无title理解可以为相同分组）

    * `<link rel="alternate stylesheet" type="text/css" href="bigtext.css" title="Big Text" />` 候选样式表(alternate style sheet)
      > 不同的候选样式，title不同。chrome无法选择候选样式，ie,firefox可以。

    * `@import url(sheet2.css) screen,print；`  
      > 出现在style元素内，在其他css规则之前，可多个@import.可用于外部样式表中。

  * 内部样式表 / 文档样式表(document style sheet)/嵌套样式表(embedded style sheet)
    * `<style type="text/css">...</style>`
  * 内联样式表
    * 作为元素的属性，如：`<p style="color:gray;">...</p>`

## 第2章 选择器

* 规则结构  
  选择器(selector)和声明块(declaration block).声明块由N个声明(declaration)组成，每个声明是一个属性-值对(property-value)。如：  
  ```css
  h1 {color: red; background: yellow;}
  ```
  
* 通配选择器:任意选择  
  ```css
  * {color: red; background: aqua;}
  ```

* 分组选择器：  
  ```css
  h1, h2 {color: red;}
  ```

* 类选择器：  
  ```css
  .warning {color: red;}
  ```

  多类选择器：class = "urgent warning"  
  ```css
  .warning.urgent {color: blue;}
  ```

* ID选择器：id属性不允许有以空格分割的词列表  
  ```css
  #first-div {color: red;}
  ```

  > 类和id可能区分大小写，取决于文档语言。html,xhtml区分大小写。

* 属性选择器(attribute selector)  
  * 简单属性选择器  
    `elm[attr] {property: value;}`
  * 具体属性选择:要求与属性值完全匹配.  
    `elm[attr="val"] {property: value;}`
    ```css
    p[class="urgent warning"] {font-weight:bold;}
    ```
    
    > id选择器和id属性选择器不是一回事。
    
  * 部分属性选择：
    > `[attr~="val"]`:任意一词,  
    `[attr^="val"]`:开头，  
    `[attr$="val"]`:结尾，  
    `[attr*="val"]`:包含字符  
    
  * 特定属性选择：
    > `[attr|="val"]`val开头或val-开头
    
* 后代选择器(descendant selector)/上下文选择器(contextual selector)：
  ```css 
  h1 em {color: red;}
  ```
  
* 儿子选择器：
  ```css 
  h1 > strong {color: red;}
  ```
  
* 相邻兄弟选择器(adjacentsibling selector)：选择相邻兄弟中的第二个元素
  ```css 
  h1 + p {color: red;}
  ```
  
* 伪类选择器(pseudo-class selector)：
  * 链接伪类：含href属性的元素。注意区别与锚点。
    > :link 未访问地址  
    > :visited 已访问的地址  
  
  * 动态伪类：用于任何元素
    > :focus 拥有输入焦点的元素  
    > :hover 鼠标悬浮的元素  
    > :active 激活的元素
  
* 第一个子元素：
  ```css 
  p:first-child {font-weight: bold;}
  ```
  
* lang()伪类：
  ```css 
  *:lang(fr) {font-style: italic;}
  ```
    
* 伪元素选择器：
  > :first-letter  
  > :first-line  
  > `h1:before {content:"text";}`  
  > `h2:after {content:"text";}`  
  > 所有伪元素必须放在出现该伪元素的选择器的最后面

## 第3章 结构和层叠

* 特殊性：
  * 内联样式：1，0，0，0
  * id属性(#)：0，1，0，0
  * 类属性(.)，属性选择(attr=val)，伪类：0，0，1，0
  * 元素，伪元素：0，0，0，1
  * 结合符，通配选择器，(非css表现提示,如font元素)：0，0，0，0
  * 继承：无特殊性
* 重要性
  * !important 重要声明，放在最后
* 继承
* 层叠
  1. 找出所有规则
  2. 按显式权重排序。!important,来源
     ``` 
     1. reader !
     2. auther !
     3. auther(网站开发者)
     4. reader(用户)
     5. (非css表现提示,如font元素)
     6. user-agent(浏览器)
     ```

  3. 按特殊性排序
  4. 按出现顺序排序(导入的样式表在前)，越后权重越大

## 第4章 值和单位

* 颜色
  * `rgb(100%, 50%, 0%)`
  * `rgb(255, 127, 0)`
  * `#ff8800`
  * `#f80`
* 长度
  * 绝对长度 
    * in
    * cm
    * mm
    * pt
    * pc
  * 相对长度
    * em:font-size
    * ex:0.5em
    * px

## 第5章 字体

* 字体系列(font family)
  * Serif 衬线字体
  * Sans-serif 无衬线字体
  * Monospace 等宽字体
  * Cursive 手写体
  * Fantasy 其他
* 指定字体
  ```css 
  h1 {font-family: Arial, "New Century Schoolbook","Karrank%", sans-serif;}
  h2 {font-family: Arial, "cursive", cursive;}
  ```
  
* 字体加粗 font-weight  
  可继承  
  100-900，9级加粗度  
  normal, bold, bolder, lighter  
  400←100←300,400←500,600→900→500  
  bolder, lighter：查找下一个可用字体（跳跃式）,没有就+-100  
* 字体大小 font-size  
  可继承计算值  
  绝对大小关键字：xx-small, x-small, small, medium, large, x-large, xx-large。根据缩放因子相对定义。  
  相对大小：larger, smaller。不限制于绝对大小范围内。  
  百分数：从父元素继承的大小计算，可积累  
  em:1em=100%  
  使用长度单位：px等  
* 字体风格 font-style  
  normal, oblique(倾斜), italic(斜体)  
* 字体变形 font-variant  
  normal, small-caps(小型大写字母)  

