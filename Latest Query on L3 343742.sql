
WITH my_cte AS ( select distinct PatientRaces.iPatID, (SELECT ','+ rc.vrace FROM 
           (SELECT Pr.iPatID,Pr.iraceID,rC.vrace FROM Patientraces Pr left JOIN RaceCodes rC ON Pr.iRaceID=rC.iRaceID) rc
            WHERE PatientRaces.iPatID = rC.iPatID
            FOR XML PATH (''),Type).value('.','varchar(max)') AS Races
           FROM PatientRaces ),

    my_cte3 AS (select distinct patientlanguages.iPatID, (SELECT ','+ lc.vLanguage FROM 
         (SELECT pl.iPatID,PL.iLanguageID,LC.vLanguage FROM PatientLanguages PL left JOIN LanguageCodes LC ON PL.iLanguageID=LC.iLanguageID) lc 
          WHERE PatientLanguages.iPatID = LC.iPatID
		FOR XML PATH (''),Type).value('.','varchar(max)') AS LANGUAGES 
			FROM patientlanguages )




select distinct
(select top 1 cast(AP.DDATE as date) from PMAPXFT AP 
where 
AP.IPATID=pat.IPATID and 
AP.VSTATUS not in ('Cancel','No Show','Rescheduled','Reschedule','revive')
and (cast(AP.DDATE as date) between GETDATE()-1460 and GETDATE()) 
order by ap.ddate desc) as [Last Appointment Date],
pat.IPATID,
pat.VAccNo [Patient Account Number], 
pat.VLNAME [Patient Last Name],
pat.VFNAME [Patient First Name],
pat.VMI [Patient Middle Initial],
pat.VADDRESS1 [Patient Address Line 1],
pat.VADDRESS2 [Patient Address Line 2],
pat.VCITY [Patient City],
pat.VSTATE [Patient State],
pat.VZIPCODE [Patient Zip],
(SELECT top 1 VPHONE_VALUE FROM PhoneTypes WHERE IENTITY_ID=PAT.IPATID AND VPhone_Type='Home' AND VEntity_Name='PATIENT') as [Patient Home Phone],
(SELECT top 1 VPHONE_VALUE FROM PhoneTypes WHERE IENTITY_ID=PAT.IPATID AND VPhone_Type='Mobile' AND VEntity_Name='PATIENT') as [Patient Cell Phone],
(SELECT top 1 VPHONE_VALUE FROM PHONETYPEs WHERE IENTITY_ID=PAT.IPATID AND VPhone_Type='Office Ph' AND VEntity_Name='PATIENT') as [Patient Work Phone],
pat.VEMAIL [Patient Email],
pat.DDOB [Patient Date of Birth],
pat.VSEX [Patient Gender],
my_cte.Races [Patient Race],
pateth.vEthnicity [Patient Ethnicity],
my_cte3.Languages [Patient Language],
pat.vssn [Patient SSN],
patemp.VNAME[Employer],
rendprov.VSSN [ Rendering Provider ID ],
refprov.VSSN [ Referring Provider ID],
patres.vRELATION [Guarantor Relationship to Patient],
patres.vLNAME[Guarantor Last Name ],
patres.vFNAME[Guarantor First Name],
patres.datDOB[Guarantor Date of Birth],
patres.vSSN [Guarantor SSN],
patres.vPHONE [Guarantor Telephone],
patres.vSEX [Guarantor Gender],
patres.vADDRESS1 [Guarantor Address Line 1],
patres.vADDRESS2[Guarantor Address Line 2] ,
patres.vCITY[Guarantor City] ,
patres.vSTATE [Guarantor State],
patres.vZIPCODE [Guarantor Zipcode] 


from PMPTXFT pat 

left join PhoneTypes pt on pat.IPATID=pt.IEntity_ID

left join  
           MY_CTE on pat.ipatid = MY_CTE.ipatid



left join
          my_cte3 on pat.ipatid = my_cte3.ipatid

left join
          PatientResponsibleparty patres on  pat.IPATID=patres.iPATID  AND  patres.bDEFAULT=1
left join
            PMESLFT patemp on pat.VEMPID = patemp.IESLID

left join 
        (select pat1.IPATID,pat1.IPRVID, prv.VSSN from PMPTXFT pat1 inner join PMPRVFT prv on pat1.IPRVID=prv.IPRVID ) as rendprov  on pat.IPATID=rendprov.IPATID

left join
           (select pat2.IPATID,pat2.IREFPRVID, prv.VSSN from PMPTXFT pat2 inner join PMPRVFT prv on pat2.IREFPRVID=prv.IPRVID ) as refprov on pat.IPATID=refprov.IPATID 

left join
			PMAPXFT AP on Pat.IPATID = AP.IPATID
left join
            ( select pat3.ipatid,pat3.iethnicityid,pat4.vethnicity from pmptxft pat3 left join EthnicityCodes pat4 on pat3.iEthnicityID=pat4.iEthnicityID) as pateth on pat.IPATID=pateth.IPATID

where AP.VSTATUS not in ('Cancel','No Show','Rescheduled','Reschedule','revive')
and (cast(AP.DDATE as date) between GETDATE()-1460 and GETDATE())
 and bInactive=0 order by 1 asc 











		   

			



