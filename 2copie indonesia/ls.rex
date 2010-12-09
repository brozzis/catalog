<RegEx Name="lslar" TriggerInsertStatement="1" Parent=""  ParentMatch="0">
  <RegularExpression>(\S+)\s+(\d)\s(\w+)\s+(\w+)\s+(\d+)\s(\w+)\s+(\d+)\s+(\S+)\s(\w+)</RegularExpression>
  <InsertStatement>INSERT INTO indonesia(size, m, d,h, name) 
VALUES($lslar.5, &amp;quot;$lslar.6&amp;quot;, $lslar.7, &amp;quot;$lslar.8&amp;quot;, &amp;quot;$lslar.9&amp;quot;);</InsertStatement>
</RegEx>
