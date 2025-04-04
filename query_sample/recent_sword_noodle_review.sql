SELECT s.sid, s.name, s.branch, r.rid, r.menu, r.reg_date FROM shops s JOIN reviews r ON (s.sid = r.sid) WHERE r.reg_date >= now() - '30 day'::interval AND r.menu LIKE '%刀削%' ORDER BY r.reg_date DESC

